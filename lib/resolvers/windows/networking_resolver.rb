# frozen_string_literal: true

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
            result || read_performance_information(fact_name)
          end
        end

        private

        def read_performance_information(fact_name)
          error = nil
          size_ptr = FFI::MemoryPointer.new(NetworkingFFI::BUFFER_LENGHT)
          adapter_addresses = FFI::MemoryPointer.new(IpAdapterAddressesLh.size, NetworkingFFI::BUFFER_LENGHT)
          flags = NetworkingFFI::GAA_FLAG_SKIP_ANYCAST | NetworkingFFI::GAA_FLAG_SKIP_MULTICAST | NetworkingFFI::GAA_FLAG_SKIP_DNS_SERVER
          0..3.times do
            error = NetworkingFFI::GetAdaptersAddresses(NetworkingFFI::AF_UNSPEC, flags, FFI::Pointer::NULL, adapter_addresses, size_ptr)
            break if error == NetworkingFFI::ERROR_SUCCES
            if error == NetworkingFFI::ERROR_BUFFER_OVERFLOW
              adapter_addresses = FFI::MemoryPointer.new(IpAdapterAddressesLh.size, NetworkingFFI::BUFFER_LENGHT)
            else
              @log.info "Unable to retrieve networking facts!"
              return nil
            end
          end
          return nil unless error.zero?
          adapter_addresses  = IpAdapterAddressesLh.new(adapter_addresses)
          iterate_list(adapter_addresses)
          @fact_list[fact_name]
        end

        def iterate_list(adapter_addresses)
          net_interface = {}
          @fact_list[:interfaces] = []
          while adapter_addresses !=  FFI::Pointer::NULL do
            @fact_list[:interfaces] << adapter_addresses[:FriendlyName]
            if adapter_addresses[:OperStatus] != NetworkingFFI::IfOperStatusUp ||
                (adapter_addresses[:Iftype] != NetworkingFFI::IF_TYPE_ETHERNET_CSMACD &&
                    adapter_addresses[:Iftype] != NetworkingFFI::IF_TYPE_IEEE80211)
              break if adapter_addresses[:Next] == FFI::Pointer::NULL
              adapter_addresses = IpAdapterAddressesLh.new(adapter_addresses[:Next])
              next
            end
            @fact_list[:domain] = adapter_addresses[:DnsSuffix]
            #net_interface[:name] = adapter_addresses.FriendlyName
            adapter_addresses = IpAdapterAddressesLh.new(adapter_addresses[:Next])
          end
        end

      end
    end
  end
end


#
# facter::util::windows::wsa winsock;
#
#
#             // Only supported on platforms after Windows Server 2003.
#             if (pCurAddr->Flags & IP_ADAPTER_DHCP_ENABLED && pCurAddr->Length >= sizeof(IP_ADAPTER_ADDRESSES_LH)) {
#                 auto adapter = reinterpret_cast<IP_ADAPTER_ADDRESSES_LH&>(*pCurAddr);
#                 if (adapter.Flags & IP_ADAPTER_DHCP_ENABLED) {
#                     try {
#                         net_interface.dhcp_server = winsock.saddress_to_string(adapter.Dhcpv4Server);
#                     } catch (wsa_exception &e) {
#                         LOG_DEBUG("failed to retrieve dhcp v4 server address for {1}: {2}", net_interface.name, e.what());
#                     }
#                 }
#             }
#
#             for (auto it = pCurAddr->FirstUnicastAddress; it; it = it->Next) {
#                 string addr;
#                 try {
#                     addr = winsock.saddress_to_string(it->Address);
#                 } catch (wsa_exception &e) {
#                     string iptype =
#                         (it->Address.lpSockaddr->sa_family == AF_INET) ? " v4"
#                         : (it->Address.lpSockaddr->sa_family == AF_INET6) ? " v6"
#                         : "";
#                     LOG_DEBUG("failed to retrieve ip{1} address for {2}: {3}",
#                         iptype, net_interface.name, e.what());
#                 }
#
#                 if (addr.empty()) {
#                     continue;
#                 }
#
#                 if (it->Address.lpSockaddr->sa_family == AF_INET || it->Address.lpSockaddr->sa_family == AF_INET6) {
#                     bool ipv6 = it->Address.lpSockaddr->sa_family == AF_INET6;
#
#                     binding b;
#                     b.address = addr;
#
#                     // Need to do lookup based on the structure length.
#                     auto adapterAddr = reinterpret_cast<IP_ADAPTER_UNICAST_ADDRESS_LH&>(*it);
#                     if (ipv6) {
#                         auto mask = create_ipv6_mask(adapterAddr.OnLinkPrefixLength);
#                         auto masked = mask_ipv6_address(it->Address.lpSockaddr, mask);
#                         b.netmask = winsock.address_to_string(mask);
#                         b.network = winsock.address_to_string(masked);
#                     } else {
#                         auto mask = create_ipv4_mask(adapterAddr.OnLinkPrefixLength);
#                         auto masked = mask_ipv4_address(it->Address.lpSockaddr, mask);
#                         b.netmask = winsock.address_to_string(mask);
#                         b.network = winsock.address_to_string(masked);
#                     }
#
#                     if (ipv6) {
#                         net_interface.ipv6_bindings.emplace_back(std::move(b));
#                     } else {
#                         net_interface.ipv4_bindings.emplace_back(std::move(b));
#                     }
#
#                     // http://support.microsoft.com/kb/894564 talks about how binding order is determined.
#                     // GetAdaptersAddresses returns adapters in binding order. This way, the domain and primary_interface match.
#                     // The old facter behavior didn't make a lot of sense (it would pick the last in binding order, not 1st).
#           // Only accept this as a primary interface if it has a non-link-local address.
#               if (result.primary_interface.empty() && (
#               (it->Address.lpSockaddr->sa_family == AF_INET && !ignored_ipv4_address(addr)) ||
#               (it->Address.lpSockaddr->sa_family == AF_INET6 && !ignored_ipv6_address(addr)))) {
#               result.primary_interface = net_interface.name;
#       }
#       }
#       }
#
#       stringstream macaddr;
#       for (DWORD i = 0u; i < pCurAddr->PhysicalAddressLength; ++i) {
#           macaddr << setfill('0') << setw(2) << hex << uppercase <<
#               static_cast<int>(pCurAddr->PhysicalAddress[i]) << ':';
#       }
#       net_interface.macaddress = macaddr.str();
#       if (!net_interface.macaddress.empty()) {
#           net_interface.macaddress.pop_back();
#       }
#
#       net_interface.mtu = pCurAddr->Mtu;
#
#       result.interfaces.emplace_back(move(net_interface));
#      }