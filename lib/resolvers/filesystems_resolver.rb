# frozen_string_literal: true

module Facter
  module Resolvers
    module Linux
      class Filesystems < BaseResolver
        @semaphore = Mutex.new
        @fact_list ||= {}
        @log = Facter::Log.new
        class << self
          def resolve(fact_name)
            @semaphore.synchronize do
              result ||= @fact_list[fact_name]
              subscribe_to_manager
              result || read_filesystems(fact_name)
            end
          end

          def read_filesystems(fact_name)
            output = File.read('/proc/filesystems')
            array1 = []
            output.each_line do |line|
              tokens = line.split(' ')
              array1 << tokens if tokens.size == 1
            end
            @fact_list[:systems] = array1.join(",")
            @fact_list[fact_name]
          end
        end
      end
    end
  end
end
