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
            output = File.read('/proc/meminfo')
            @fact_list[:total] = output.match(/MemTotal:\s+(\d+)\s/)[1].to_i * 1024
            @fact_list[:memfree] = output.match(/MemFree:\s+(\d+)\s/)[1].to_i * 1024
            @fact_list[:swap_total] = output.match(/SwapTotal:\s+(\d+)\s/)[1].to_i * 1024
            @fact_list[:swap_free] = output.match(/SwapFree:\s+(\d+)\s/)[1].to_i * 1024
            lis(fact_name)
          end

          def lis(fact_name)
            if @fact_list[:total].zero? || @fact_list[:memfree].zero? || @fact_list[:swap_total].zero? ||
                @fact_list[:swap_free].zero?
              @log.debug 'Total or Available memory is equal to zero, could not proceed further!'
            else
              caller_use
              caller_cap
              @fact_list[fact_name]
            end
          end

          def caller_cap
            @fact_list[:capacity] = format('%.2f',
                                           (@fact_list[:used_bytes] / @fact_list[:total].to_f * 100)) + '%'
            @fact_list[:scapacity] = format('%.2f',
                                            (@fact_list[:sused_bytes] / @fact_list[:swap_total].to_f * 100)) + '%'
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
