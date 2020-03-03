# frozen_string_literal: true

module Facts
  module El
    class Kernelversion
      FACT_NAME = 'kernelversion'

      def call_the_resolver
        fact_value = Facter::Resolvers::Uname.resolve(:kernelrelease)
        Facter::ResolvedFact.new(FACT_NAME, version(fact_value))
      end

      private

      def version(fact_value)
        version_token = fact_value.split('-')
        version_token[0]
      end
    end
  end
end
