# frozen_string_literal: true

module Facter
  module Resolvers
    module Solaris
      class ZFS < BaseResolver
        @log = Facter::Log.new(self)
        @semaphore = Mutex.new
        @fact_list ||= {}
        class << self
          private

          def post_resolve(fact_name)
            @fact_list.fetch(fact_name) { zfs_fact(fact_name) }
          end

          def zfs_fact(fact_name)
            build_zfs_facts
            @fact_list[fact_name]
          end

          def build_zfs_facts
            output, _status = Open3.capture2('zfs upgrade -v')
            feature_numbers = output.scan(/^\s+(\d+)/).flatten
            @fact_list[:zfs_featurenumbers] = feature_numbers.join(', ')
            @fact_list[:zfs_version] = feature_numbers.last
          end
        end
      end
    end
  end
end
