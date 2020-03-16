# frozen_string_literal: true

module Facts
  module El
    module Memory
      module Swap
        class Available
          FACT_NAME = 'memory.swap.available'
          ALIASES = 'swapfree'

          def call_the_resolver
            fact_value = Facter::Resolvers::Linux::Memory.resolve(:swap_free)
            fact_value = Facter::BytesToHumanReadable.convert(fact_value)
            [Facter::ResolvedFact.new(FACT_NAME, fact_value), Facter::ResolvedFact.new(ALIASES, fact_value, :legacy)]
          end
        end
      end
    end
  end
end
