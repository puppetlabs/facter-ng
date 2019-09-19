# frozen_string_literal: true

module Facter
  module Windows
    class RubySitedir
      FACT_NAME = 'ruby.sitedir'

      def call_the_resolver
        fact_value = RubyResolver.resolve(:sitedir)

        ResolvedFact.new(FACT_NAME, fact_value)
      end
    end
  end
end
