# frozen_string_literal: true

module Facter
  module Aix
    class Identity
      FACT_NAME = 'identity'

      def call_the_resolver
        identity_value = {
            :user => Resolvers::PosixIdentity.resolve(:user),
            :uid => Resolvers::PosixIdentity.resolve(:uid),
            :gid => Resolvers::PosixIdentity.resolve(:gid),
            :group => Resolvers::PosixIdentity.resolve(:group),
            :privileged => Resolvers::PosixIdentity.resolve(:privileged)
        }

        ResolvedFact.new(FACT_NAME, identity_value)
      end
    end
  end
end
