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
            if line.match(/MemTotal:/)
              @fact_list[:total] = line.match(/\d+/).to_i * 1024
            elsif line.match(/MemFree:|Buffers:|Cache:/)
              @fact_list[:memfree] = line.match(/\d+/).to_i * 1024
            elsif line.match(/SwapTotal:/)
              @fact_list[:swap_total] = line.match(/\d+/).to_i * 1024
            elsif line.match(/SwapFree:/)
              @fact_list[:swap_free] = line.match(/\d+/).to_i * 1024
            end
          end
          @fact_list[fact_name]
        end
      end
    end
  end
  end
  end
