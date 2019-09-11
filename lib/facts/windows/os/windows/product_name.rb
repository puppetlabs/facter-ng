# frozen_string_literal: true

module Facter
  module Windows
    class OsWindowsProductName
      FACT_NAME = 'os.windows.product_name'

      def call_the_resolver
        fact_value = ProductReleaseResolver.resolve(:product_name)

        Fact.new(FACT_NAME, fact_value)
      end
    end
  end
end
