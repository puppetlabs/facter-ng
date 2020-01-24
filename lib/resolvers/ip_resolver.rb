# frozen_string_literal: true

module Facter
  module Resolvers
    class Ip < BaseResolver
      @semaphore = Mutex.new

      class << self
        private

        def post_resolve(fact_name)
          retrieve_ip(fact_name) if @fact_list.nil?

          @fact_list[fact_name]
        end

        def retrieve_ip(fact_name)
          @fact_list ||= {}

          retrieve_default_interface_and_ip
          retrieve_interface_info

          @fact_list[fact_name]
        end


        def parse_ip_address
          output, _status = Open3.capture2('ip address')
          lines = output.read.split("\n")

          i = 0
          while i < lines.size
            if lines[i] =~ /[0-9]+\:/
              interface_info = lines[i]
              mac_info = lines[i + 1]
              i += 2
            end

            while !lines[i].nil? && lines[i].strip.start_with?('inet ')
              inet_info = lines[i] + '\n' + lines[i + 1]
              i += 2
            end

            while !lines[i].nil? && lines[i].strip.start_with?('inet6 ')
              inet6_info = lines[i] + '\n' + lines[i + 1]
              i += 2
            end
          end
          #lines.inspect
        end


        def retrieve_interface_info
          output, _status = Open3.capture2('ip -o address')
          interfaces = {}

          output.each_line do |ip_line|
            ip_tokens = ip_line.split(' ')

            fill_ip_v4_info!(ip_tokens, interfaces)
            fill_io_v6_info!(ip_tokens, interfaces)
          end

          @fact_list[:interfaces] = interfaces
        end

        def fill_ip_v4_info!(ip_tokens, network_info)
          return unless ip_tokens[2].casecmp?('inet')

          interface_name = ip_tokens[1]
          ip4_info = ip_tokens[3].split('/')
          ip4_address = ip4_info[0]
          ip4_mask_length = ip4_info[1]

          binding = build_binding(ip4_address, ip4_mask_length)
          build_network_info_structure!(network_info, interface_name, 'bindings')

          network_info[interface_name]['bindings'] << binding
        end

        def fill_io_v6_info!(ip_tokens, network_info)
          return unless ip_tokens[2].casecmp?('inet6')

          interface_name = ip_tokens[1]
          ip6_info = ip_tokens[3].split('/')
          ip6_address = ip6_info[0]
          ip6_mask_length = ip6_info[1]

          binding = build_binding(ip6_address, ip6_mask_length)

          build_network_info_structure!(network_info, interface_name, 'bindings6')

          network_info[interface_name]['bindings6'] << binding
        end

        def retrieve_default_interface_and_ip
          output, _status = Open3.capture2('ip route get 1')

          ip_route_tokens = output.each_line.first.strip.split(' ')
          default_interface = ip_route_tokens[4]
          default_ip = ip_route_tokens[6]

          @fact_list[:ip] = default_ip
          @fact_list[:interface] = default_interface
        end

        def build_binding(addr, mask_length)
          require 'ipaddr'

          ip = IPAddr.new(addr)
          mask = if ip.ipv6?
                   IPAddr.new('ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff').mask(mask_length)
                 else
                   IPAddr.new('255.255.255.255').mask(mask_length)
                 end
          { address: addr, netmask: mask, network: ip.mask(mask_length) }
        end

        def build_network_info_structure!(network_info, interface_name, binding)
          network_info[interface_name] = {} unless network_info.dig(interface_name)
          network_info[interface_name][binding] = [] unless network_info.dig(interface_name, binding)
        end
      end
    end
  end
end
