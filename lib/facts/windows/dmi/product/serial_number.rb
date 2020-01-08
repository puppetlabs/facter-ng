# frozen_string_literal: true

module Facter
  module Windows
    class DmiProductSerialNumber
      FACT_NAME = 'dmi.product.serial_number'
      ALIASES = 'serialnumber'

      def call_the_resolver
        fact_value = Resolvers::DMIBios.resolve(:serial_number)

        [ResolvedFact.new(FACT_NAME, fact_value), ResolvedFact.new(ALIASES, fact_value, :legacy)]
      end
    end
  end
end
