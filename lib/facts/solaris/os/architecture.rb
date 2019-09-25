# frozen_string_literal: true

module Facter
  module Solaris
    class OsArchitecture
      FACT_NAME = 'os.architecture'

      def call_the_resolver
        fact_value = Facter::Resolvers::Uname.resolve(:machine)
        ResolvedFact.new(FACT_NAME, fact_value)
      end
    end
  end
end
