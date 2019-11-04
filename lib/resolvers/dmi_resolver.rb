# frozen_string_literal: true

module Facter
  module Resolvers
    module Linux
      class DMIBios < BaseResolver
        @log = Facter::Log.new
        @semaphore = Mutex.new
        @fact_list ||= {}

        class << self
          # Manufacturer
          # SerialNumber

          def resolve(fact_name)
            @semaphore.synchronize do
              result ||= @fact_list[fact_name]
              subscribe_to_manager
              result || read_facts(fact_name)
            end
          end

            private

          def read_facts(fact_name)
            files = %w[bios_date bios_vendor bios_version board_vendor board_name board_serial chassis_asset_tag
                       chassis_type sys_vendor product_name product_serial product_uuid]
            files.each do |element|
              unless File.exist?("/sys/class/dmi/#{element}")
                @log.debug "File /sys/class/dmi/#{element} does not exist!"
                next
              end
              @fact_list[element.to_sym] = File.read("/sys/class/dmi/#{element}")
            end
            @fact_list[fact_name]
          end
          end
      end
    end
  end
end
