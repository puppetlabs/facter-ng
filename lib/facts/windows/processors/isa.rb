# frozen_string_literal: true

module Facter
  module Windows
    class ProcessorsIsa
      FACT_NAME = 'processors.isa'
      ALIASES = 'hardwareisa'

      def call_the_resolver
        fact_value = Resolvers::Processors.resolve(:isa)

        [ResolvedFact.new(FACT_NAME, fact_value), ResolvedFact.new(ALIASES, fact_value, :legacy)]
      end
    end
  end
end
