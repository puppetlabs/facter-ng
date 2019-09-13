# frozen_string_literal: true

module Facter
  module Aix
    class OsHardware
      FACT_NAME = 'os.hardware'

      def call_the_resolver
<<<<<<< HEAD
        fact_value = Resolvers::Hardware.resolve(:hardware)
=======
        fact_value = HardwareResolver.resolve(:hardware)
>>>>>>> (FACT-2014) Added facts for aix

        ResolvedFact.new(FACT_NAME, fact_value)
      end
    end
  end
end
