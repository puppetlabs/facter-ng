# frozen_string_literal: true

module Facter
  module Windows
    class OsReleaseFull
      FACT_NAME = 'os.release.full'

      def call_the_resolver
        fact_value = WinOsReleaseResolver.resolve(:full)

        Fact.new(FACT_NAME, fact_value)
      end
    end
  end
end
