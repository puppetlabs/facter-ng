# frozen_string_literal: true

module Facter
  module Resolvers
    module Windows
      class AioAgentVersion < BaseResolver
        REGISTRY_PATH = 'SOFTWARE\\Puppet Labs\\Puppet'
        @semaphore = Mutex.new
        @fact_list ||= {}

        class << self
          private

          def post_resolve(fact_name)
            @fact_list.fetch(fact_name) { read_version(fact_name) }
          end

          def read_version(fact_name)
            ::Win32::Registry::HKEY_LOCAL_MACHINE.open(REGISTRY_PATH) do |reg|
              build_fact_list(reg)
            end

            @fact_list[fact_name]
          rescue Win32::Registry::Error
            log.debug("The registry path #{REGISTRY_PATH} does not exist")
          end

          def build_fact_list(reg)
            puppet_aio_path = read_for_64_bit(reg) || read_for_32_bit(reg)

            return unless puppet_aio_path

            puppet_aio_version_path = File.join(puppet_aio_path, 'VERSION')
            @fact_list[:aio_version] = Util::FileHelper.safe_read(puppet_aio_version_path, nil)&.chomp
          end

          def read_for_64_bit(reg)
            reg.read('RememberedInstallDir64')[1]
          rescue Win32::Registry::Error
            log.debug('Could not read Puppet AIO path from 64 bit registry')
            nil
          end

          def read_for_32_bit(reg)
            reg.read('RememberedInstallDir')[1]
          rescue Win32::Registry::Error
            log.debug('Could not read Puppet AIO path from 32 bit registry')
            nil
          end
        end
      end
    end
  end
end
