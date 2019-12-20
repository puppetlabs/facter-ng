# frozen_string_literal: true

module Facter
  module Resolvers
    module Macosx
      class Filesystems < BaseResolver
        # :macosx_filesystems
        @semaphore = Mutex.new
        @fact_list ||= {}
        @log = Facter::Log.new(self)
        class << self
          def resolve(fact_name)
            @semaphore.synchronize do
              result ||= @fact_list[fact_name]
              subscribe_to_manager
              result || read_filesystems(fact_name)
            end
          end

          def read_filesystems(fact_name)
            output, _status = Open3.capture2('mount')
            @fact_list[:macosx_filesystems] = output
            @fact_list[fact_name]
          end
        end
      end
    end
  end
end
