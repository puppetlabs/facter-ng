# frozen_string_literal: true

module Facter
  module Windows
    class HypervisorsXen
      FACT_NAME = 'hypervisors.xen'

      def call_the_resolver
        fact_value = {context: is_hvm? ? 'hvm': 'pv'} if Resolvers::Virtualization.resolve(:virtual) == 'xen'

        ResolvedFact.new(FACT_NAME, fact_value)
      end

      private

      def is_hvm?
        Resolvers::Virtualization.resolve(:model) =~ /^HVM/
      end
    end
  end
end
