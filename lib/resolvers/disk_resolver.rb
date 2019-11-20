# frozen_string_literal: true

module Facter
  module Resolvers
    module Linux
      class Disk < BaseResolver
        @log = Facter::Log.new
        @semaphore = Mutex.new
        @fact_list ||= {}

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
            read_sr0(fact_name)
            read_sda(fact_name)
            @fact_list[fact_name]
          end

          def read_sr0(fact_name)
            @fact_list[:sr0_model] = File.read('/sys/block/sr0/device/model').strip
            @fact_list[:sr0_size] = File.read('/sys/block/sr0/size').strip.to_i * 1024
            @fact_list[:sr0_vendor] = File.read('/sys/block/sr0/device/vendor').strip
          end

          def read_sda(fact_name)
            @fact_list[:sda_model] = File.read('/sys/block/sda/device/model').strip
            @fact_list[:sda_size] = File.read('/sys/block/sda/size').strip.to_i * 1024
            @fact_list[:sda_vendor] = File.read('/sys/block/sda/device/vendor').strip
          end
        end
      end
    end
  end
end
