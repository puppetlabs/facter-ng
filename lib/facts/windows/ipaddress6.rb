# frozen_string_literal: true

module Facter
  module Windows
    class Ipaddress6
      FACT_NAME = 'ipaddress6'
      FACT_TYPE = :legacy

      def initialize(*args)
        @log = Log.new
        @log.debug 'Dispatching to resolve: ' + args.inspect
      end

      def call_the_resolver
        fact_value = Resolvers::Networking.resolve(:ip6)

        ResolvedFact.new(FACT_NAME, fact_value)
      end
    end
  end
end
