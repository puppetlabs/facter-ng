# frozen_string_literal: true

module Facts
  module El
    module Memory
      module Swap
        class AvailableBytes
          FACT_NAME = 'memory.swap.available_bytes'
          ALIASES = 'swapfree_mb'

          def call_the_resolver
            fact_value = Facter::Resolvers::Linux::Memory.resolve(:swap_free)
            [Facter::ResolvedFact.new(FACT_NAME, fact_value),
             Facter::ResolvedFact.new(ALIASES, fact_value ? (fact_value / (1024.0 * 1024.0)).round(2) : nil, :legacy)]
          end
        end
      end
    end
  end
end
