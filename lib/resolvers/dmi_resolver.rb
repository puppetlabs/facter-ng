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
            build_bios
            build_board
            build_chassis
            @fact_list[:manufacturer] = File.read('/sys/class/dmi/sys_vendor') # wanted to copy the example cuz I can
            build_product
            @fact_list[fact_name]
          end

          def build_bios
            @fact_list[:bios_release_date] = File.read('/sys/class/dmi/bios_date')
            @fact_list[:bios_vendor] = File.read('/sys/class/dmi/bios_vendor')
            @fact_list[:bios_version] = File.read('/sys/class/dmi/bios_version')
          end

          def build_board
            @fact_list[:board_manufacturer] = File.read('/sys/class/dmi/board_vendor')
            @fact_list[:board_product] = File.read('/sys/class/dmi/board_name')
            @fact_list[:board_serialnumber] = File.read('/sys/class/dmi/board_serial')
          end

          def build_chassis
            @fact_list[:chassis_asset_tag] = File.read('/sys/class/dmi/chassis_asset_tag')
            @fact_list[:chassis_type] = File.read('/sys/class/dmi/chassis_type')
          end

          def build_product
            @fact_list[:product_name] = File.read('/sys/class/dmi/product_name')
            @fact_list[:product_serialnumber] = File.read('/sys/class/dmi/product_serial')
            @fact_list[:product_uuid] = File.read('/sys/class/dmi/product_uuid')
          end
        end
      end
    end
  end
end
