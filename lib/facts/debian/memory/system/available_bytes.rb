# frozen_string_literal: true

module Facts
  module Debian
    module Memory
      module System
        class AvailableBytes
          FACT_NAME = 'memory.system.available_bytes'
          ALIASES = 'memoryfree_mb'

          def call_the_resolver
            fact_value = Facter::Resolvers::Linux::Memory.resolve(:memfree)

            [Facter::ResolvedFact.new(FACT_NAME, fact_value),
             Facter::ResolvedFact.new(ALIASES, Facter::FactsUtils::BytesConverter.to_mb(fact_value), :legacy)]
          end
        end
      end
    end
  end
end
