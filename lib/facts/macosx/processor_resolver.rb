# frozen_string_literal: true

module Facter
  module Resolvers
    class Processors < BaseResolver
      @log = Facter::Log.new(self)
      @semaphore = Mutex.new
      @fact_list ||= {}
      @items = { logical_count: 'hw.logicalcpu_max',
                 physical_count: 'hw.physicalcpu_max',
                 brand: 'machdep.cpu.brand_string',
                 speed: 'hw.cpufrequency_max' }
      class << self
        # Count
        # Models
        # PhysicalCount
        # Speed
        def resolve(fact_name)
          @semaphore.synchronize do
            result ||= @fact_list[fact_name]
            subscribe_to_manager
            result || read_processor_data(fact_name)
          end
        end

        private

        def read_processor_data(fact_name)
          output, _status = Open3.capture2("sysctl #{@items.values.join(' ')}")
          build_fact_list(output.split("\n"))
          @fact_list[fact_name]
        end

        def build_fact_list(result)
          build_logical_count(result[0])
          build_physical_count(result[1])
          build_models(result[2])
          build_speed(result[3])
        end

        def build_logical_count(count)
          @fact_list[:logicalcount] = count.split(': ').fetch(1).to_i
        end

        def build_physical_count(count)
          @fact_list[:physicalcount] = count.split(': ').fetch(1).to_i
        end

        def build_models(model)
          brand = model.split(': ').fetch(1)
          @fact_list[:models] = Array.new(@fact_list[:logicalcount].to_i).fill(brand)
        end

        def build_speed(value)
          @fact_list[:speed] = convert_hz(value.split(': ').fetch(1).to_i)
        end

        def convert_hz(speed)
          prefix = { 3 => 'k', 6 => 'M', 9 => 'G', 12 => 'T' }
          power = Math.log10(speed).floor
          speed.fdiv(10**power).to_s + ' ' + prefix[power] + 'Hz'
        end
      end
    end
  end
end
