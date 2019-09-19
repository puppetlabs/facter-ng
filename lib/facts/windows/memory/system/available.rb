# frozen_string_literal: true

module Facter
  module Windows
    class MemorySystemAvailable
      FACT_NAME = 'memory.system.available'

      def call_the_resolver
        fact_value = MemoryResolver.resolve(:available_bytes)
        fact_value = BytesToHumanReadable.convert(fact_value)
        ResolvedFact.new(FACT_NAME, fact_value)
      end
    end
  end
end
