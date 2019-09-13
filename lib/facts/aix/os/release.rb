# frozen_string_literal: true

module Facter
  module Aix
    class OsRelease
      FACT_NAME = 'os.release'

      def call_the_resolver
<<<<<<< HEAD
        fact_value = Resolvers::OsLevel.resolve(:build)
=======
        fact_value = OsLevelResolver.resolve(:build)
>>>>>>> (FACT-2014) Added facts for aix
        major = fact_value.split('-')[0]

        ResolvedFact.new(
          FACT_NAME,
          full: fact_value.strip,
          major: major
        )
      end
    end
  end
end
