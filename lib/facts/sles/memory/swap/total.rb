# frozen_string_literal: true

module Facts
  module Sles
    module Memory
      module Swap
        class Total
          FACT_NAME = 'memory.swap.total'
          ALIASES = 'swapsize'

          def call_the_resolver
            fact_value = Facter::Resolvers::Linux::Memory.resolve(:swap_total)
            fact_value = Facter::BytesToHumanReadable.convert(fact_value)
            [Facter::ResolvedFact.new(FACT_NAME, fact_value), Facter::ResolvedFact.new(ALIASES, fact_value, :legacy)]
          end
        end
      end
    end
  end
end
