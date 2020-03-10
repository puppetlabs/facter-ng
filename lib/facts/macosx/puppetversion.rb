# frozen_string_literal: true

module Facts
  module Macosx
    class Puppetversion
      FACT_NAME = 'puppetversion'

      def call_the_resolver
        require 'puppet/version'
        fact_value = Puppet.version.to_s

        Facter::ResolvedFact.new(FACT_NAME, fact_value)
      end
    end
  end
end
