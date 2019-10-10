# frozen_string_literal: true

require 'ipaddr'

module Facter
  module Resolvers
    class Networking < BaseResolver
      @log = Facter::Log.new
      @semaphore = Mutex.new
      @fact_list ||= {}
      class << self
        def resolve(fact_name)
          @semaphore.synchronize do
            result ||= @fact_list[fact_name]
            subscribe_to_manager
            result || read_network_information(fact_name)
          end
        end

        private

        def read_network_information(fact_name)
          size_ptr = FFI::MemoryPointer.new(NetworkingFFI::BUFFER_LENGTH)
          adapter_addresses = FFI::MemoryPointer.new(IpAdapterAddressesLh.size, NetworkingFFI::BUFFER_LENGTH)
          flags = NetworkingFFI::GAA_FLAG_SKIP_ANYCAST |
                  NetworkingFFI::GAA_FLAG_SKIP_MULTICAST | NetworkingFFI::GAA_FLAG_SKIP_DNS_SERVER

          return nil unless (adapter_addresses = get_adapter_addresses(size_ptr, adapter_addresses, flags))

          adapter_addresses = IpAdapterAddressesLh.new(adapter_addresses)
          iterate_list(adapter_addresses)
          set_interfaces_other_facts
          @fact_list[fact_name]
        end

        def get_adapter_addresses(size_ptr, adapter_addresses, flags)
          error = nil
          3.times do
            error = NetworkingFFI::GetAdaptersAddresses(NetworkingFFI::AF_UNSPEC, flags,
                                                        FFI::Pointer::NULL, adapter_addresses, size_ptr)
            break if error == NetworkingFFI::ERROR_SUCCES

            if error == NetworkingFFI::ERROR_BUFFER_OVERFLOW
              adapter_addresses = FFI::MemoryPointer.new(IpAdapterAddressesLh.size, NetworkingFFI::BUFFER_LENGTH)
            else
              @log.info 'Unable to retrieve networking facts!'
              return nil
            end
          end
          return nil unless error.zero?

          adapter_addresses
        end

        def adapter_is_not_up(adapter)
          adapter[:OperStatus] != NetworkingFFI::IF_OPER_STATUS_UP ||
            (adapter[:IfType] != NetworkingFFI::IF_TYPE_ETHERNET_CSMACD &&
                adapter[:IfType] != NetworkingFFI::IF_TYPE_IEEE80211)
        end

        def retrieve_dhcp_server(adapter)
          if adapter[:Flags] & NetworkingFFI::IP_ADAPTER_DHCP_ENABLED &&
             adapter[:Union][:Struct][:Length] >= IpAdapterAddressesLh.size
            NetworkUtils.address_to_string(adapter[:Dhcpv4Server])
          end
        end

        def iterate_list(adapter_addresses)
          net_interface = {}
          while adapter_addresses.to_ptr != FFI::Pointer::NULL
            if adapter_is_not_up(adapter_addresses)
              adapter_addresses = IpAdapterAddressesLh.new(adapter_addresses[:Next])
              next
            end
            @fact_list[:domain] ||= adapter_addresses[:DnsSuffix].read_wide_string
            name = adapter_addresses[:FriendlyName].read_wide_string.to_sym
            net_interface[name] = {}
            dhcp = retrieve_dhcp_server(adapter_addresses)
            net_interface[name][:dhcp] = dhcp if dhcp
            net_interface[name][:mtu] = adapter_addresses[:Mtu]

            bindings = find_ip_addresses(adapter_addresses[:FirstUnicastAddress], name)
            net_interface[name][:bindings] = bindings[:ipv4] unless bindings[:ipv4].empty?
            net_interface[name][:bindings6] = bindings[:ipv6] unless bindings[:ipv6].empty?
            net_interface[name][:mac] = NetworkUtils.find_mac_address(adapter_addresses)
            adapter_addresses = IpAdapterAddressesLh.new(adapter_addresses[:Next])
          end
          @fact_list[:interfaces] = net_interface
        end

        def find_ip_addresses(unicast_addresses, name)
          bindings = {}
          bindings[:ipv6] = bindings[:ipv4] = []
          unicast = IpAdapterUnicastAddressLH.new(unicast_addresses)
          while unicast.to_ptr != FFI::Pointer::NULL
            addr = NetworkUtils.address_to_string(unicast[:Address])
            unless addr
              unicast = IpAdapterUnicastAddressLH.new(unicast[:Next])
              next
            end

            addr = addr.split('%').first
            sock_addr = SockAddr.new(unicast[:Address][:lpSockaddr])
            b = find_bindings(sock_addr, unicast, addr)
            bindings[:ipv6] << b if b && !b.empty? && b[:network].ipv4?
            bindings[:ipv4] << b if b && !b.empty? && b[:network].ipv6?
            find_primary_interface(sock_addr, name, addr)
            unicast = IpAdapterUnicastAddressLH.new(unicast[:Next])
          end
          bindings
        end

        def find_bindings(sock_addr, unicast, addr)
          return if sock_addr[:sa_family] != NetworkingFFI::AF_INET && sock_addr[:sa_family] != NetworkingFFI::AF_INET6

          NetworkUtils.build_binding(addr, unicast[:OnLinkPrefixLength])
        end

        def find_primary_interface(sock_addr, name, addr)
          if !@fact_list[:primary_interface] &&
             (sock_addr[:sa_family] == NetworkingFFI::AF_INET && !NetworkUtils.ignored_ipv4_address(addr)) ||
             (sock_addr[:sa_family] == NetworkingFFI::AF_INET6 && !NetworkUtils.ignored_ipv6_address(addr))
            @fact_list[:primary] = name
          end
        end

        def set_interfaces_other_facts
          bind = {}
          @fact_list[:interfaces].each do |interface_name, value|
            value[:bindings].each do |binding|
              unless NetworkUtils.ignored_ipv4_address(binding[:address])
                bind = binding
                break
              end
            end
            populate_interface(bind, value)

            value[:bindings6].each do |binding|
              unless NetworkUtils.ignored_ipv4_address(binding[:address])
                bind = binding
                break
              end
            end
            populate_interface(bind, value)
            build_mtu_mac_facts(value, interface_name)
          end
        end

        def populate_interface(bind, interface)
          return if bind.empty?

          if bind[:network].ipv6?
            interface[:ip6] = bind[:address]
            interface[:netmask6] = bind[:netmask]
            interface[:network6] = bind[:network]
          else
            interface[:network] = bind[:network]
            interface[:netmask] = bind[:netmask]
            interface[:ip] = bind[:address]
          end
        end

        def build_mtu_mac_facts(value, interface_name)
          return unless @fact_list[:primary] == interface_name

          @fact_list[:mtu] ||= value[:mtu]
          @fact_list[:mac] ||= value[:mac]
        end
      end
    end
  end
end
