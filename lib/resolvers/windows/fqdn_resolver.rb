# frozen_string_literal: true
require 'win32/registry'

class FqdnResolver < BaseResolver
  @log = Facter::Log.new

  class << self
    @@semaphore = Mutex.new
    @@fact_list ||= {}

    def resolve(fact_name)
      @@semaphore.synchronize do
        result ||= @@fact_list[fact_name]
        result || build_fact_list(fact_name)
      end
    end

    def invalidate_cache
      @@fact_list = {}
    end

    private

    def get_hostname
      output, _status = Open3.capture2('hostname')
      output.strip
    end

    def get_domain
      win = Win32Ole.new
      win.exec_query('select DNSDomain from Win32_NetworkAdapterConfiguration where IPEnabled = True').each do |ceva|
        if ceva.DNSDomain && ceva.DNSDomain.length > 0
          return ceva.DNSDomain
          break
        end
      end
    end

    def compose_fqdn(hostname, domain)
      if hostname and domain
        return [hostname, domain].join(".")
      end
      hostname
    end

    def build_fact_list(fact_name)
      domain = get_domain
      hostname = get_hostname
      @@fact_list[:domain] = domain
      @@fact_list[:hostname] = hostname
      @@fact_list[:fqdn] = compose_fqdn(hostname, domain)
      @@fact_list[fact_name]
    end
  end
end


