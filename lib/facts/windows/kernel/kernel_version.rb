# frozen_string_literal: true

module Facter
  module Windows
    class KernelVersion
      FACT_NAME = 'kernelversion'

      def call_the_resolver
        fact_value = KernelResolver.resolve(:kernelversion)

<<<<<<< HEAD
        Fact.new(FACT_NAME, fact_value)
=======
        ResolvedFact.new(FACT_NAME, fact_value)
>>>>>>> fb08b0b67d14e86d033b885bcecd3c84a3769691
      end
    end
  end
end
