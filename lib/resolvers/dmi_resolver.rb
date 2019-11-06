# frozen_string_literal: true

module Facter
  module Resolvers
    module Linux
      class DMIBios < BaseResolver
        @log = Facter::Log.new
        @semaphore = Mutex.new
        @fact_list ||= {}

        class << self
          # :bios_vendor
          # :bios_release_date
          # :bios_version
          # :board_vendor
          # :board_serial_number
          # :board_manufacturer
          # :chassis_asset_tag
          # :chassis_type
          # :manufacturer
          # :product_serial_number
          # :product_manufacturer
          # :product_uuid

          def resolve(fact_name)
            @semaphore.synchronize do
              result ||= @fact_list[fact_name]
              subscribe_to_manager
              result || read_facts(fact_name)
            end
          end

          private

          def read_facts(_fact_name)
            files = %w[bios_date bios_vendor bios_version board_vendor board_name board_serial chassis_asset_tag
                       chassis_type sys_vendor product_name product_serial product_uuid]
            types = ['Other', 'Unknown', 'Desktop', 'Low Profile Desktop', 'Pizza Box', 'Mini Tower', 'Tower',
                     'Portable', 'Laptop', 'Notebook', 'Hand Held', 'Docking Station', 'All in One', 'Sub Notebook',
                     'Space-Saving', 'Lunch Box', 'Main System Chassis', 'Expansion Chassis', 'SubChassis',
                     'Bus Expansion Chassis', 'Peripheral Chassis', 'Storage Chassis', 'Rack Mount Chassis',
                     'Sealed-Case PC', 'Multi-system', 'CompactPCI', 'AdvancedTCA', 'Blade', 'Blade Enclosure',
                     'Tablet', 'Convertible', 'Detachable']
            files.each do |element|
              unless File.exist?("/sys/class/dmi/id/#{element}")
                @log.debug "File /sys/class/dmi/id/#{element} does not exist!"
                next
              end
              if element == 'chassis_type'
                token = File.read("/sys/class/dmi/id/chassis_type")
                @fact_list[:chassis_type] = types[token - 1]
              end
              @fact_list[element.to_sym] = File.read("/sys/class/dmi/id/#{element}")
            end
            @fact_list[fact_name]
          end
        end
      end
    end
  end
end
