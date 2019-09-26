# frozen_string_literal: true

module Facter
  module Windows
    class OsRelease
      FACT_NAME = 'os.release'

      def call_the_resolver
        input = {
          consumerrel: Resolvers::WinOsDescription.resolve(:consumerrel),
          description: Resolvers::WinOsDescription.resolve(:description),
          version: Resolvers::Kernel.resolve(:kernelmajorversion),
          kernel_version: Resolvers::Kernel.resolve(:kernelversion)
        }

        fact_value = WindowsReleaseFinder.find_release(input)
        ResolvedFact.new(FACT_NAME, full: fact_value, major: fact_value)
      end
    end
  end
end
