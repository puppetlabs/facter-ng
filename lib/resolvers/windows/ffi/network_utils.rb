# frozen_string_literal: true

class NetworkUtils
  @log = Facter::Log.new(self)
  class << self
    def address_to_string(addr)
      return if addr[:lpSockaddr] == FFI::Pointer::NULL

      size = FFI::MemoryPointer.new(NetworkingFFI::INET6_ADDRSTRLEN + 1)
      buffer = FFI::MemoryPointer.new(:wchar, NetworkingFFI::INET6_ADDRSTRLEN + 1)
      error = nil
      3.times do
        error = NetworkingFFI::WSAAddressToStringW(addr[:lpSockaddr], addr[:iSockaddrLength],
                                                   FFI::Pointer::NULL, buffer, size)
        break if error.zero?
      end
      unless error.zero?
        @log.debug 'address to string translation failed!'
        return
      end
      extract_address(buffer)
    end

    def extract_address(addr)
      addr.read_wide_string_without_length.split('%').first
    end

    def ignored_ip_address(addr)
      addr.empty? || addr.start_with?('127.', '169.254.') || addr.start_with?('fe80') || addr.eql?('::1')
    end

    def find_mac_address(adapter)
      adapter[:PhysicalAddress].first(adapter[:PhysicalAddressLength])
                               .map { |e| format('%<mac_address>02x', mac_address: e.to_i) }
                               .join(':').upcase
    end

    def build_binding(addr, mask_length)
      ip = IPAddr.new(addr)
      mask = if ip.ipv6?
               IPAddr.new('ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff').mask(mask_length)
             else
               IPAddr.new('255.255.255.255').mask(mask_length)
             end
      { address: addr, netmask: mask.to_s, network: ip.mask(mask_length).to_s }
    end

    def get_scope(sockaddr)
      require 'socket'
      scope6 = []
      addrinfo = Addrinfo.new(['AF_INET6', 0, nil, sockaddr], :INET6)

      scope6 << 'compat,' if addrinfo.ipv6_v4compat?
      scope6 << if addrinfo.ipv6_linklocal?
                  'link'
                elsif addrinfo.ipv6_sitelocal?
                  'site'
                elsif addrinfo.ipv6_loopback?
                  'host'
                else 'global'
                end
      scope6.join
    end
  end
end
