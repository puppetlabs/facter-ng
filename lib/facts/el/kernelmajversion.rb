# frozen_string_literal: true

module Facts
  module El
    class Kernelmajversion
      FACT_NAME = 'kernelmajversion'

      def call_the_resolver
        fact_value = Facter::Resolvers::Uname.resolve(:kernelrelease)
        Facter::ResolvedFact.new(FACT_NAME, major_version(fact_value))
      end

      private

      def major_version(fact_value)
        value_split = fact_value.split('.')
        return value_split[0] if value_split.length <= 1

        value_split[0] + '.' + value_split[1]
      end
    end
  end
end
