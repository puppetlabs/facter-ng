# frozen_string_literal: true

module Facter
  module Resolvers
    class SolarisSwap < BaseResolver
      @log = Facter::Log.new
      @semaphore = Mutex.new
      @fact_list ||= {}

      class << self
        def resolve(fact_name)
          @semaphore.synchronize do
            result ||= @fact_list[fact_name]
            subscribe_to_manager
            result || build_facts(fact_name)
          end
        end

        # private

        #
        # def build_facts(_fact_name)
        #   state_ptr = FFI::MemoryPointer.new
        # end
      end
    end
  end
end
