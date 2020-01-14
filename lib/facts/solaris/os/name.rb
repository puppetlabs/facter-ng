# frozen_string_literal: true

module Facter
  module Solaris
    class OsName
      FACT_NAME = 'os.name'
      ALIASES = 'operatingsystem'

      def call_the_resolver
        value = Resolvers::Uname.resolve(:kernelname)
        fact_value = value == 'SunOS' ? 'Solaris' : value

        [ResolvedFact.new(FACT_NAME, fact_value), ResolvedFact.new(ALIASES, fact_value, :legacy)]
      end
    end
  end
end
