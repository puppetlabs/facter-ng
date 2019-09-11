# frozen_string_literal: true

require 'win32/registry'

class ProductReleaseResolver < BaseResolver
  @log = Facter::Log.new

  class << self
    @@semaphore = Mutex.new
    @@fact_list ||= {}

    def resolve(fact_name)
      @@semaphore.synchronize do
        result ||= @@fact_list[fact_name]
        result || read_fact_from_registry(fact_name)
      end
    end

    def invalidate_cache
      @@fact_list = {}
    end

    private

    def read_fact_from_registry(fact_name)
      reg = ::Win32::Registry::HKEY_LOCAL_MACHINE.open('SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion')
      build_fact_list(reg)

      @@fact_list[fact_name]
    end

    def build_fact_list(reg)
      @@fact_list[:edition_id] = reg['EditionID']
      @@fact_list[:installation_type] = reg['InstallationType']
      @@fact_list[:product_name] = reg['ProductName']
      @@fact_list[:release_id] = reg['ReleaseId']
    end
  end
end
