# frozen_string_literal: true

module Facts
  module Sles
    class Interfaces
      FACT_NAME = 'interfaces'

      def call_the_resolver
        fact_value = Facter::Resolvers::NetworkingLinux.resolve(:interfaces)

        Facter::ResolvedFact.new(FACT_NAME, fact_value.empty? ? nil : fact_value.keys.join(','), :legacy)
      end
    end
  end
end
