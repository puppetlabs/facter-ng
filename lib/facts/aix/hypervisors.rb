# frozen_string_literal: true

module Facter
  module Aix
    class Hypervisors
      FACT_NAME = 'hypervisors'

      def call_the_resolver
        ResolvedFact.new(FACT_NAME, fact_value)
      end

      private

      def fact_value
        {}.tap do |hash|
          hash['wpar'] = wpar_fact if wpar_fact
          hash['lpar'] = lpar_fact if lpar_fact
        end
      end

      def wpar_fact
        wpar_key = Resolvers::Lpar.resolve(:wpar_key)
        return unless wpar_key&.positive?

        { key: wpar_key, configured_id: Resolvers::Lpar.resolve(:wpar_configured_id) }
      end

      def lpar_fact
        lpar_partition_number = Resolvers::Lpar.resolve(:lpar_partition_number)
        return unless lpar_partition_number&.positive?

        { partition_number: lpar_partition_number, partition_name: Resolvers::Lpar.resolve(:lpar_partition_name) }
      end
    end
  end
end
