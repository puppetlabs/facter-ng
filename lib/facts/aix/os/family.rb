# frozen_string_literal: true

module Facter
  module Aix
    class OsFamily
      FACT_NAME = 'os.family'

      def call_the_resolver
<<<<<<< HEAD
        fact_value = Resolvers::Uname.resolve(:kernelname)
=======
        fact_value = UnameResolver.resolve(:kernelname)
>>>>>>> (FACT-2014) Added facts for aix
        ResolvedFact.new(FACT_NAME, fact_value)
      end
    end
  end
end
