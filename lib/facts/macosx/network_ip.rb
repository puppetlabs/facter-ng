# frozen_string_literal: true

module Facter
  module Macosx
    class NetworkIP
      FACT_NAME = 'networking.ip'

      def call_the_resolver
        Fact.new(FACT_NAME, nil)
      end
    end
  end
end
