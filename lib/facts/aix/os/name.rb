# frozen_string_literal: true

module Facter
  module Aix
    class OsName
      FACT_NAME = 'os.name'

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
