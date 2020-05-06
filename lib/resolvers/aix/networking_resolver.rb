# frozen_string_literal: true

module Facter
  module Resolvers
    module Aix
      class Networking < BaseResolver
        @semaphore = Mutex.new
        @fact_list ||= {}

        class << self
          private

          def post_resolve(fact_name)
            @fact_list.fetch(fact_name) { read_netstat(fact_name) }
          end

          def read_netstat(fact_name)
            output = Facter::Core::Execution.execute('netstat -rn', logger: log)
            output = output.split("\n").select { |line| (line =~ /\s\s[0-9]+.[0-9]+.[0-9]+.[0-9]+|\s\s.*:[0-9a-f]+/) }
            get_primary_interface_info(output)

            @fact_list[fact_name]
          end

          def get_primary_interface_info(output)
            primary_interface_info = output.find { |line| line =~ /=>/ }.split(' ')
            @fact_list[:primary] = primary_interface_info[5]
            @fact_list[:ip] = primary_interface_info[1]
          end
        end
      end
    end
  end
end
