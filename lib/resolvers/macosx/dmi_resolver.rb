# frozen_string_literal: true

module Facter
  module Resolvers
    module Macosx
      class DmiBios < BaseResolver
        @log = Facter::Log.new
        @semaphore = Mutex.new
        @fact_list ||= {}

        class << self
          #:model

          def resolve(fact_name)
            @semaphore.synchronize do
              result ||= @fact_list[fact_name]
              subscribe_to_manager
              result || read_facts(fact_name)
            end
          end

          private

          def read_facts(fact_name)
            # OSX only supports the product name
            @fact_list[:model], _status = Open3.capture2('sysctl -n hw.model')
            @fact_list[fact_name]
          end
        end
      end
    end
  end
end
