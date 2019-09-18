# frozen_string_literal: true

module Facter
  module Windows
    class OsReleaseMajor
      FACT_NAME = 'os.release.major'

      def call_the_resolver
        fact_value = WinOsReleaseResolver.resolve(:major)

        ResolvedFact.new(FACT_NAME, fact_value)
      end
    end
  end
end
