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
            processors = create_processors(cpuinfo_output)

            processors_count = processor_count(processors)
            models = processor_models(processors)
            physical_ids = physical_processors(processors)

            crete_cache(processors_count, models, physical_ids)

            @fact_list[fact_name]
          end

          def create_processors(cpuinfo_output)
            processors = []

            cpuinfo_output.split(/^\n/).each do |processor_string|
              processor =  Hash.new { |h,k| h[k] = [] }

              processor_string.each_line do |line|
                tokens = line.split(':')
                processor[tokens.first.strip] = tokens.last.strip
              end

              processors << processor
            end

            processors
          end

          def processor_count(processors)
            processors.size
          end

          def processor_models(processors)
            models = []

            processors.each do |processor|
              models << processor['model name']
            end

            models
          end

          def physical_processors(processors)
            physical_ids = []

            processors.each do |processor|
              physical_ids << processor['physical id']
            end

            physical_ids.uniq.size
          end

          def crete_cache(count_processors, models, counter_physical_processors)
            @fact_list[:processors] = count_processors
            @fact_list[:models] = models
            @fact_list[:physical_processors] = counter_physical_processors
          end

        end
      end
    end
  end
end
