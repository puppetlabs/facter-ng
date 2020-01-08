# frozen_string_literal: true

module Facter
  module Windows
    class IdentityUser
      FACT_NAME = 'identity.user'
      ALIASES = 'id'

      def call_the_resolver
        fact_value = Resolvers::Identity.resolve(:user)

        [ResolvedFact.new(FACT_NAME, fact_value), ResolvedFact.new(ALIASES, fact_value, :legacy)]
      end
    end
  end
end
