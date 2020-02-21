# frozen_string_literal: true

module Facter
  module Solaris
    class ZpoolVersion
      FACT_NAME = 'zpool_version'

      def call_the_resolver
        fact_value = Resolvers::Solaris::Zpool.resolve(:zpool_version)
        ResolvedFact.new(FACT_NAME, fact_value)
      end
    end
  end
end
