# frozen_string_literal: true

module Facter
  module Solaris
    class MemorySwap
      FACT_NAME = 'memory.swap'

      def call_the_resolver
        fact_value = 'should call a resolver'
        ResolvedFact.new(FACT_NAME, fact_value)
      end
    end
  end
end
