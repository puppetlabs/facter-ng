# frozen_string_literal: true

module Facter
  module Resolvers
    module Linux
      class Memory < BaseResolver
        @semaphore = Mutex.new
        @fact_list ||= {}
        @log = Facter::Log.new
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
            lis(fact_name)
          end

          def lis(fact_name)
            if (@fact_list[:total].zero? || @fact_list[:memfree].zero? || @fact_list[:swap_total].zero? || @fact_list[:swap_free]).zero?
              @log.debug 'Total or Available memory is equal to zero, could not proceed further!'
            else
              caller_use
              caller_cap
              @fact_list[fact_name]
            end
          end

          def caller_cap
            @fact_list[:capacity] = format('%.2f',(@fact_list[:used_bytes] / @fact_list[:total].to_f * 100)) + '%'
            @fact_list[:scapacity] = format('%.2f',(@fact_list[:sused_bytes] / @fact_list[:swap_total].to_f * 100)) + '%'
          end

          def caller_use
            @fact_list[:used_bytes] = (@fact_list[:total] - @fact_list[:memfree])
            @fact_list[:sused_bytes] = (@fact_list[:swap_total] - @fact_list[:swap_free])
          end
        end
      end
    end
  end
end
