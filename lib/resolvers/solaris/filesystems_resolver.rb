# frozen_string_literal: true

module Facter
  module Resolvers
    module Solaris
      class Filesystem < BaseResolver
        @semaphore = Mutex.new
        @fact_list ||= {}

        class << self
          private

          def post_resolve(fact_name)
            @fact_list.fetch(fact_name) { read_sysdef_file(fact_name) }
          end

          def read_sysdef_file(fact_name)
            file_content = Facter::Resolvers::Utils::FileHelper.safe_readlines('/usr/sbin/sysdef', nil)
            return unless file_content

            files = file_content.map do |line|
              line.split('/').last.strip if line =~ /^fs\.*/
            end

            @fact_list[:file_systems] = files.compact.sort.join(',')
            @fact_list[fact_name]
          end
        end
      end
    end
  end
end
