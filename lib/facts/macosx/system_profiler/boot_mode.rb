# frozen_string_literal: true

module Facts
  module Macosx
    module SystemProfiler
      class BootMode
        FACT_NAME = 'system_profiler.boot_mode'

        def call_the_resolver
          fact_value = Facter::Resolvers::SystemProfiler.resolve(:boot_mode)
          Facter::ResolvedFact.new(FACT_NAME, fact_value)
        end
      end
    end
  end
end
