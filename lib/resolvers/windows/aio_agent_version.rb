
# frozen_string_literal: true

module Facter
  module Resolvers
    class AioAgentVersion < BaseResolver
      @semaphore = Mutex.new
      @fact_list ||= {}

      class << self
        private

        def post_resolve(fact_name)
          @fact_list.fetch(fact_name) { read_version(fact_name) }
        end


        def read_version(fact_name)
          reg = ::Win32::Registry::HKEY_LOCAL_MACHINE.open('SOFTWARE\\Puppet Labs\\Puppet')
          build_fact_list(reg)
          reg.close

          @fact_list[fact_name]
        end

        def build_fact_list(reg)
          puppet_aio_path = reg.read('RememberedInstallDir64')[1]
          puppet_aio_version_path = File.join(puppet_aio_path, 'VERSION')

          aio_version  = Util::FileHelper.safe_read(puppet_aio_version_path, nil)
          @fact_list[:aio_version] = aio_version
        rescue Win32::Registry::Error => e
          log.error("Could not read Puppet AIO path from registry")
          @fact_list[:aio_version] = nil
        end
      end
    end
  end
end
