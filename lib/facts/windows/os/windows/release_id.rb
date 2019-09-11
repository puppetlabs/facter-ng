# frozen_string_literal: true

module Facter
  module Windows
    class OsWindowsReleaseID
      FACT_NAME = 'os.windows.release_id'

      def call_the_resolver
        fact_value = ProductReleaseResolver.resolve(:release_id)

        Fact.new(FACT_NAME, fact_value)
      end
    end
  end
end
