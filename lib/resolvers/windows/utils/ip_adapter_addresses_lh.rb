# frozen_string_literal: true

MAX_DNS_SUFFIX_STRING_LENGTH = 256
MAX_ADAPTER_ADDRESS_LENGTH = 8
MAX_DHCPV6_DUID_LENGTH = 130

class SockAddr < FFI::Struct
  layout(
      :sa_family, :ushort,
      :sa_data,  [:uint8, 14]
  )
end

class SocketAddress < FFI::Struct
  layout(
      :lpSockaddr, SockAddr,
      :iSockaddrLength, :int32
  )
end

class IpAdapterMulticastAddressXPUnionStruct < FFI::Struct
  layout(
      :Lenght, :win32_ulong,
      :Flags, :dword
  )
end

class IpAdapterMulticastAddressXPUnion < FFI::Union
  layout(
      :Alogment, :ulong_long,
      :Struct, IpAdapterMulticastAddressXPUnionStruct
  )
end

class IpAdapterMulticastAddressXP < FFI::Struct
  layout(
      :Union,  IpAdapterMulticastAddressXPUnion,
      :Next, :pointer,
      :Address, SocketAddress
  )
end

class IpAdapterUnicastAddressLH < FFI::Struct
  layout(
      :Union, IpAdapterMulticastAddressXPUnion,
      :Next, :pointer,
      :Address, SocketAddress,
      :PrefixOrigin, :uint8,
      :SuffixOrigin, :uint16,
      :DadState, :uint16,
      :ValidLifetime, :win32_ulong,
      :PreferredLifetime, :win32_ulong,
      :LeaseLifetime, :win32_ulong,
      :OnLinkPrefixLength, :uint8
  )
end

class IpAdapterPrefixXPUnionStruct < FFI::Struct
  layout(
      :Lenght, :win32_ulong,
      :Reserved, :dword
  )
end

class IpAdapterPrefixXPUnion < FFI::Union
  layout(
      :Alogment, :ulong_long,
      :Struct, IpAdapterPrefixXPUnionStruct
  )
end

class IpAdapterPrefixXP < FFI::Struct
  layout(
      :Union,  IpAdapterPrefixXPUnion,
      :Next, :pointer,
      :Address, SocketAddress,
      :PrefixLenght, :win32_ulong
  )
end

class IpAdapterGatewayUnionStruct < FFI::Struct
  layout(
      :Lenght, :win32_ulong,
      :Reserved, :dword
  )
end

class IpAdapterGatewayAddressLHUnion < FFI::Union
  layout(
      :Alogment, :ulong_long,
      :Struct, IpAdapterGatewayUnionStruct
  )
end

class IpAdapterGatewayAddressLH < FFI::Struct
    layout(
      :Union,  IpAdapterGatewayAddressLHUnion,
      :Next, :pointer,
      :Address, SocketAddress
    )
end

class NetLuidLHStruct < FFI::Struct
  layout(
      :Reserved, :ulong_long,
      :NetLuidIndex, :ulong_long,
      :IfType, :ulong_long
  )
end

class NetLuidLH < FFI::Union
  layout(
      :Value, :ulong_long,
      :Info, NetLuidLHStruct
  )
end

class IpAdapterDNSSuffix < FFI::Struct
  layout(
      :Next, :pointer,
      :String, [:wchar, MAX_DNS_SUFFIX_STRING_LENGTH]
  )
end

class AdapterAddressFlagsUnionStruct < FFI::Struct
  layout(
      :DdnsEnabled, :win32_ulong,
      :RegisterAdapterSuffix, :win32_ulong,
      :Dhcpv4Enabled, :win32_ulong,
      :ReceiveOnly, :win32_ulong,
      :NoMulticast, :win32_ulong,
      :Ipv6OtherStatefulConfig, :win32_ulong,
      :NetbiosOverTcpipEnabled, :win32_ulong,
      :Ipv4Enabled, :win32_ulong,
      :Ipv6Enabled, :win32_ulong,
      :Ipv6ManagedAddressConfigurationSupported, :win32_ulong
  )
end

class AdapterAddressFlagsUnion < FFI::Union
  layout(
      :Flags, :win32_ulong,
      :Struct, AdapterAddressFlagsUnionStruct
  )
end

class AdapterAddressAligmentUnionStruct < FFI::Struct
  layout(
      :Lenght, :win32_ulong,
      :IfIndex, :dword
  )
end

class AdapterAddressAligmentUnion < FFI::Union
  layout(
      :Aligment, :uint64,
      :Struct, AdapterAddressAligmentUnionStruct
  )
end

class Friendly < FFI::Struct
  layout(
      :FriendlyName, :wchar
  )
end

class IpAdapterAddressesLh < FFI::Struct
  layout(
      :Union1, AdapterAddressAligmentUnion,
      :Next, :pointer,
      :AdapterName, :pointer,
      :FirstUnicastAddress, IpAdapterUnicastAddressLH,
      :FirstAnycastAddress, IpAdapterMulticastAddressXP,
      :FirstMulticastAddress, IpAdapterMulticastAddressXP,
      :FirstDnsServerAddress, IpAdapterGatewayAddressLH,
      :DnsSuffix, :pointer,
      :Description, :pointer,
      :FriendlyName, :pointer,
      :PhysicalAddress, [:uchar, MAX_ADAPTER_ADDRESS_LENGTH],
      :PhysicalAddressLength, :win32_ulong,
      :Union2, AdapterAddressFlagsUnion,
      :Mtu, :win32_ulong,
      :IfType, :dword,
      :OperStatus, :uint8,
      :Ipv6IfIndex, :dword,
      :ZoneIndices, [:win32_ulong, 16],
      :FirstPrefix, IpAdapterPrefixXP,
      :TransmitLinkSpeed, :ulong_long,
      :ReceiveLinkSpeed, :ulong_long,
      :FirstWinsServerAddress, IpAdapterGatewayAddressLH,
      :FirstGatewayAddress, IpAdapterGatewayAddressLH,
      :Ipv4Metric, :win32_ulong,
      :Ipv6Metric, :win32_ulong,
      :Luid, NetLuidLH,
      :Dhcpv4Server, SocketAddress,
      :CompartmentId, :uint32,
      :NetworkGuid, :int,
      :ConnectionType, :uint8,
      :TunnelType, :uint16,
      :Dhcpv6Server, SocketAddress,
      :Dhcpv6ClientDuid, [:uint8, MAX_DHCPV6_DUID_LENGTH],
      :Dhcpv6ClientDuidLength, :win32_ulong,
      :Dhcpv6Iaid, :win32_ulong,
      :FirstDnsSuffix, IpAdapterDNSSuffix
  )
end
