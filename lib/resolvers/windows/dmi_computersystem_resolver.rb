# frozen_string_literal: true

module Facter
  module Resolvers
    class DMIComputerSystemResolver < BaseResolver
      @log = Facter::Log.new
      @semaphore = Mutex.new
      @fact_list ||= {}

      class << self
        # Name
        # UUID

        def resolve(fact_name)
          @semaphore.synchronize do
            result ||= @fact_list[fact_name]
            subscribe_to_manager
            result || read_fact_from_computer_system(fact_name)
          end
        end

        private

        def read_fact_from_computer_system(fact_name)
          win = Win32Ole.new
          computersystem = win.return_first('SELECT Name,UUID FROM Win32_ComputerSystemProduct')
          unless computersystem
            @log.debug 'WMI query returned no results for Win32_ComputerSystemProduct with values Name and UUID.'
            return
          end

          build_fact_list(computersystem)

          @fact_list[fact_name]
        end

        def build_fact_list(computersys)
          @fact_list[:name] = computersys.Name
          @fact_list[:uuid] = computersys.UUID
        end
      end
    end
  end
end
