# frozen_string_literal: true

module Facter
  module Macosx
    class OsMacosxBuild
      FACT_NAME = 'os.macosx.build'

      def call_the_resolver
        fact_value = Resolvers::SwVers.resolve(:buildversion)

        ResolvedFact.new(FACT_NAME, fact_value)
      end
    end
  end
end
