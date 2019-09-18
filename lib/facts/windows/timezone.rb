# frozen_string_literal: true

module Facter
  module Windows
    class Timezone
      FACT_NAME = 'timezone'

      def call_the_resolver
        fact_value = TimezoneResolver.resolve(:timezone)

        ResolvedFact.new(FACT_NAME, fact_value)
      end
    end
  end
end
