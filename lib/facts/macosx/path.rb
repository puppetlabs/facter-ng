# frozen_string_literal: true

module Facter
  module Macosx
    class Path
      FACT_NAME = 'path'

      def call_the_resolver
        fact_value = PathResolver.resolve(:path)

<<<<<<< HEAD
        Fact.new(FACT_NAME, fact_value)
=======
        ResolvedFact.new(FACT_NAME, fact_value)
>>>>>>> fb08b0b67d14e86d033b885bcecd3c84a3769691
      end
    end
  end
end
