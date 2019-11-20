# frozen_string_literal: true

module Facter
  module Resolvers
    module Linux
      class Disk < BaseResolver
        @log = Facter::Log.new
        @semaphore = Mutex.new
        @fact_list ||= {}
        DIR = '/sys/block/'
        FILE_PATHS = { sr0_model: 'sr0/device/model', sr0_size: 'sr0/size', sr0_vendor: 'sr0/device/vendor',
                       sda_model: 'sda/device/model', sda_size: 'sda/size', sda_vendor: 'sda/device/vendor' }.freeze
        class << self
          # :sr0_model
          # :sr0_size
          # :sr0_vendor
          # :sda_model
          # :sda_size
          # :sda_vendor

          def resolve(fact_name)
            @semaphore.synchronize do
              result ||= @fact_list[fact_name]
              subscribe_to_manager
              result || read_facts(fact_name)
            end
          end

          def read_facts(fact_name)
            return nil unless File.exist?(DIR + FILE_PATHS[fact_name])

            result = File.read(DIR + FILE_PATHS[fact_name]).strip
            @fact_list[fact_name] = fact_name.to_s =~ /size/ ? result.to_i * 1024 : result
          end
        end
      end
    end
  end
end
