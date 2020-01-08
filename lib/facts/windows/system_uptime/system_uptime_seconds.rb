# frozen_string_literal: true

module Facter
  module Windows
    class SystemUptimeSeconds
      FACT_NAME = 'system_uptime.seconds'
      ALIASES = 'uptime_seconds'

      def call_the_resolver
        fact_value = Resolvers::Windows::Uptime.resolve(:seconds)

        [ResolvedFact.new(FACT_NAME, fact_value), ResolvedFact.new(ALIASES, fact_value, :legacy)]
      end
    end
  end
end
