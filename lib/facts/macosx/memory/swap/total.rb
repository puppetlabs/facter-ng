# frozen_string_literal: true

module Facts
  module Macosx
    module Memory
      module Swap
        class Total
          FACT_NAME = 'memory.swap.total'

          def call_the_resolver
            fact_value = Facter::Resolvers::Macosx::SwapMemory.resolve(:total_bytes)
            fact_value = Facter::BytesToHumanReadable.convert(fact_value)

            Facter::ResolvedFact.new(FACT_NAME, fact_value)
          end
        end
      end
    end
  end
end
