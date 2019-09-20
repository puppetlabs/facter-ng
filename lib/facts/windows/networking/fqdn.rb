# frozen_string_literal: true

module Facter
  module Windows
    class NetworkingFqdn
      FACT_NAME = 'networking.fqdn'

      def call_the_resolver
        fact_value = FqdnResolver.resolve(:fqdn)

        ResolvedFact.new(FACT_NAME, fact_value)
      end
    end
  end
end

