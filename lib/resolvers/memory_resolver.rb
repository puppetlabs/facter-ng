# frozen_string_literal: true

module Facter
  module Resolvers
    module Linux
      class Memory < BaseResolver
        @semaphore = Mutex.new
        @fact_list ||= {}

        class << self
          def resolve(fact_name)
            @semaphore.synchronize do
              result ||= @fact_list[fact_name]
              subscribe_to_manager
              result || read_meminfo_file(fact_name)
            end
          end

          def read_meminfo_file(fact_name)
            output, _status = Open3.capture2('cat /proc/meminfo')
            output.each_line do |line|
              result = line.match(/\d+/).to_s.to_i * 1024
              @fact_list[:total] = result if line.match(/MemTotal:/)
              @fact_list[:memfree] ||= result if line.match(/MemFree:|Buffers:|Cache:/)
              @fact_list[:swap_total] = result if line.match(/SwapTotal:/)
              @fact_list[:swap_free] = result if line.match(/SwapFree:/)
            end
            @fact_list[:used_bytes] = (@fact_list[:total] - @fact_list[:memfree])
            @fact_list[:sused_bytes] = (@fact_list[:swap_total] - @fact_list[:swap_free])
            @fact_list[:capacity] = ((@fact_list[:used_bytes] / @fact_list[:total]) * (100 / 100))
            @fact_list[:scapacity] = ((@fact_list[:sused_bytes] / @fact_list[:swap_total]) * (100 / 100))
            @fact_list[fact_name]
          end
        end
      end
    end
  end
end