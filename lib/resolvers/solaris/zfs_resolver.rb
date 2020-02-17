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
            feature_numbers, version = ZPoolZFSParser.feature_numbers_and_version(zfs: true)
            @fact_list[:zfs_featurenumbers] = feature_numbers
            @fact_list[:zfs_version] = version
          end
        end
      end
    end
  end
end
