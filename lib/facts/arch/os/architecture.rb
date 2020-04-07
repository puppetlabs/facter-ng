# frozen_string_literal: true

module Facts
  module Arch
    module Os
      class Architecture
        FACT_NAME = 'os.architecture'
        ALIASES = 'architecture'

        def call_the_resolver
          fact_value = Facter::Resolvers::Uname.resolve(:machine)
          fact_value = 'amd64' if fact_value == 'x86_64'

          [Facter::ResolvedFact.new(FACT_NAME, fact_value), Facter::ResolvedFact.new(ALIASES, fact_value, :legacy)]
        end
      end
    end
  end
end
