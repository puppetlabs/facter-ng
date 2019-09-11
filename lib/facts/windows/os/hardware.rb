# frozen_string_literal: true

module Facter
  module Windows
    class OsHardware
      FACT_NAME = 'os.hardware'

      def call_the_resolver
        fact_value = HardwareArchitectureResolver.resolve(:hardware)

        Fact.new(FACT_NAME, fact_value)
      end
    end
  end
end
