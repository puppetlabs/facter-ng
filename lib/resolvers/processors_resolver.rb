# frozen_string_literal: true

module Facter
  module Resolvers
    module Linux
      class Processors < BaseResolver
        @log = Facter::Log.new
        @semaphore = Mutex.new
        @fact_list ||= {}
        class << self
          # Count
          # Models
          # PhysicalCount
          def resolve(fact_name)
            @semaphore.synchronize do
              result ||= @fact_list[fact_name]
              subscribe_to_manager
              result || read_cpuinfo(fact_name)
            end
          end

          private

          def read_cpuinfo(fact_name)
            cpuinfo_output = File.read('/proc/cpuinfo')
            read_processors(cpuinfo_output) # + model names
            read_physical_processors(cpuinfo_output)

            @fact_list[fact_name]
          end

          def read_processors(cpuinfo_output)
            count_processors = 0
            models = []
            cpuinfo_output.each_line do |line|
              tokens = line.split(':')
              count_processors += 1 if tokens.first.strip == 'processor'
              models << tokens.last.strip if tokens.first.strip == 'model name'
            end
            @fact_list[:processors] = count_processors
            @fact_list[:models] = models
          end

          def read_physical_processors(cpuinfo_output)
            counter_physical_processors = []
            cpuinfo_output.each_line do |line|
              tokens = line.split(':')
              counter_physical_processors.unshift(tokens.last.strip.to_i) if tokens.first.strip == 'physical id'
            end
            @fact_list[:physical_processors] = counter_physical_processors.uniq.length
          end
        end
      end
    end
  end
end
