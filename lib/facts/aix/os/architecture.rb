# frozen_string_literal: true

module Facter
  module Aix
    class OsArchitecture
      FACT_NAME = 'os.architecture'

      def call_the_resolver
<<<<<<< HEAD
        fact_value = Resolvers::Architecture.resolve(:architecture)
=======
        fact_value = ArchitectureResolver.resolve(:architecture)
>>>>>>> (FACT-2014) Added facts for aix

        ResolvedFact.new(FACT_NAME, fact_value)
      end
    end
  end
end
