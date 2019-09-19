# frozen_string_literal: true

module Facter
  module Windows
    class MemorySystemTotalBytes
      FACT_NAME = 'memory.system.total_bytes'

      def call_the_resolver
        fact_value = MemoryResolver.resolve(:total_bytes)

        ResolvedFact.new(FACT_NAME, fact_value)
      end
    end
  end
end
