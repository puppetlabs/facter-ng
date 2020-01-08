# frozen_string_literal: true

module Facter
  module Windows
    class DmiProductName
      FACT_NAME = 'dmi.product.name'
      ALIASES = 'productname'

      def call_the_resolver
        fact_value = Resolvers::DMIComputerSystem.resolve(:name)

        [ResolvedFact.new(FACT_NAME, fact_value), ResolvedFact.new(ALIASES, fact_value, :legacy)]
      end
    end
  end
end
