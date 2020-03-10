# frozen_string_literal: true

module Facts
  module Debian
    module Processors
      class Isa
        FACT_NAME = 'processors.isa'
        ALIASES = 'hardwareisa'

        def call_the_resolver
          fact_value = Facter::Resolvers::Uname.resolve(:processor)

          [Facter::ResolvedFact.new(FACT_NAME, get_isa(fact_value)),
           Facter::ResolvedFact.new(ALIASES, get_isa(fact_value), :legacy)]
        end

        private

        def get_isa(fact_value)
          value_split = fact_value.split('.')

          value_split.last
        end
      end
    end
  end
end
