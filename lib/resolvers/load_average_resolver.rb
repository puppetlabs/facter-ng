# frozen_string_literal: true

module Facter
  module Resolvers
    module Linux
      class LoadAverage < BaseResolver
        @log = Facter::Log.new
        @semaphore = Mutex.new
        @fact_list ||= {}
        class << self
          # :loadavrg
          def resolve(fact_name)
            @semaphore.synchronize do
              result ||= @fact_list[fact_name]
              result || read_loadavrg_file(fact_name)
            end
          end

          private

          def read_loadavrg_file(fact_name)
            output = File.read('/proc/loadavg')
            averages = output.split(' ')
            @fact_list[:loadavrg] = {}
            @fact_list[:loadavrg].store('1min', averages[0])
            @fact_list[:loadavrg].store('5min', averages[1])
            @fact_list[:loadavrg].store('15min', averages[2])
            @fact_list[fact_name]
          end
        end
      end
    end
  end
end
