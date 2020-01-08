# frozen_string_literal: true

module Facter
  module Windows
    class NetworkingIp6
      FACT_NAME = 'networking.ip6'
      ALIASES = 'ipaddress6'

      def call_the_resolver
        fact_value = Resolvers::Networking.resolve(:ip6)

        [ResolvedFact.new(FACT_NAME, fact_value), ResolvedFact.new(ALIASES, fact_value, :legacy)]
      end
    end
  end
end
