# frozen_string_literal: true

module Facts
  module Aix
    class AioAgentVersion
      FACT_NAME = 'aio_agent_version'

      def call_the_resolver
        fact_value = Facter::Resolvers::Agent.resolve(:aio_agent_version)
        Facter::ResolvedFact.new(FACT_NAME, fact_value)
      end
    end
  end
end
