# frozen_string_literal: true

module Facter
  module Windows
    class DmiManufacturer
      FACT_NAME = 'dmi.manufacturer'
      ALIASES = 'manufacturer'

      def call_the_resolver
        fact_value = Resolvers::DMIBios.resolve(:manufacturer)

        [ResolvedFact.new(FACT_NAME, fact_value), ResolvedFact.new(ALIASES, fact_value, :legacy)]
      end
    end
  end
end
