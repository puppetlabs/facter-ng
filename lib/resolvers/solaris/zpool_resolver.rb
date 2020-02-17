# frozen_string_literal: true

require_relative '../utils/zfs_zpool_parser'

module Facter
  module Resolvers
    module Solaris
      class ZPool < BaseResolver
        @log = Facter::Log.new(self)
        @semaphore = Mutex.new
        @fact_list ||= {}
        class << self
          private

          def post_resolve(fact_name)
            @fact_list.fetch(fact_name) { zpool_fact(fact_name) }
          end

          def zpool_fact(fact_name)
            build_zpool_facts
            @fact_list[fact_name]
          end

          def build_zpool_facts
            feature_numbers, version = ZPoolZFSParser.feature_numbers_and_version(zpool: true)
            @fact_list[:zpool_featurenumbers] = feature_numbers
            @fact_list[:zpool_version] = version
          end
        end
      end
    end
  end
end
