# frozen_string_literal: true

module NetworkingFFI
  extend FFI::Library

  ffi_convention :stdcall
  ffi_lib :iphlpapi
  attach_function :GetAdaptersAddresses, %i[uint32 uint32 pointer pointer pointer], :dword

  AF_UNSPEC = 0
  GAA_FLAG_SKIP_ANYCAST = 2
  GAA_FLAG_SKIP_MULTICAST = 4
  GAA_FLAG_SKIP_DNS_SERVER = 8
  BUFFER_LENGHT = 15000
  ERROR_SUCCES = 0
  ERROR_BUFFER_OVERFLOW = 111
  IfOperStatusUp = 1
  IF_TYPE_ETHERNET_CSMACD = 6
  IF_TYPE_IEEE80211 = 71
  IP_ADAPTER_DHCP_ENABLED = 4
end

