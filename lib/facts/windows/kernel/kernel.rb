# frozen_string_literal: true

module Facter
  module Windows
    class Kernel
      FACT_NAME = 'kernel'

      def call_the_resolver
        fact_value = KernelResolver.resolve(:kernel)

<<<<<<< HEAD
        Fact.new(FACT_NAME, fact_value)
=======
        ResolvedFact.new(FACT_NAME, fact_value)
>>>>>>> fb08b0b67d14e86d033b885bcecd3c84a3769691
      end
    end
  end
end
