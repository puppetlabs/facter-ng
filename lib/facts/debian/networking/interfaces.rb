# frozen_string_literal: true

module Facter
  module Debian
    class Interfaces
      FACT_NAME = 'networking.interfaces'

      def call_the_resolver
        fact_value = Facter::Resolvers::Ip.resolve(:interfaces)
        ResolvedFact.new(FACT_NAME, fact_value)
      end
    end
  end
end
