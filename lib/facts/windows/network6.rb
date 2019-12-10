# frozen_string_literal: true

module Facter
  module Windows
    class Network6
      FACT_NAME = 'network6'
      FACT_TYPE = :legacy

      def initialize(*args)
        @log = Log.new
        @log.debug 'Dispatching to resolve: ' + args.inspect
      end

      def call_the_resolver
        fact_value = Resolvers::Networking.resolve(:network6)

        ResolvedFact.new(FACT_NAME, fact_value)
      end
    end
  end
end
