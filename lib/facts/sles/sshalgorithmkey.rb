# frozen_string_literal: true

module Facts
  module Sles
    class Sshalgorithmkey
      FACT_NAME = 'ssh.*key'

      def call_the_resolver
        facts = []
        result = Facter::Resolvers::SshResolver.resolve(:ssh)
        result.each { |ssh| facts << Facter::ResolvedFact.new("ssh#{ssh.name.to_sym}key", ssh.key, :legacy) }
        facts
      end
    end
  end
end
