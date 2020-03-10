# frozen_string_literal: true

module Facts
  module Sles
    class SshfpAlgorithm
      FACT_NAME = 'sshfp_.*'

      def call_the_resolver
        arr = []
        result = Facter::Resolvers::SshResolver.resolve(:ssh)
        result.each do |ssh|
          arr << Facter::ResolvedFact.new("sshfp_#{ssh.name.to_sym}",
                                          "#{ssh.fingerprint.sha1}\n#{ssh.fingerprint.sha256}", :legacy)
        end
        arr
      end
    end
  end
end
