# frozen_string_literal: true

module Facter
  module Fedora
    class Kernelmajversion
      FACT_NAME = 'kernelmajversion'

      def call_the_resolver
        fact_value = Resolvers::Uname.resolve(:kernelmajversion)
        ResolvedFact.new(FACT_NAME, fact_value)
      end
    end
  end
end
