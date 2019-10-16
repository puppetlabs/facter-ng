# frozen_string_literal: true

module Facter
  module Fedora
    class AioAgentVersion
      FACT_NAME = 'aio_agent_version'

      def call_the_resolver
        fact_value = Resolvers::Agent.resolve(:aio_agent_version)
        ResolvedFact.new(FACT_NAME, fact_value)
      end
    end
  end
end
