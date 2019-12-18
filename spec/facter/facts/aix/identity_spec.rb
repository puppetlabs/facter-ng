# frozen_string_literal: true

describe 'Aix Identity' do
  context '#call_the_resolver' do
    it 'returns a fact' do
      expected_fact = %w(
                  {
                    gid => 0,
                    group => "system",
                    privileged => true,
                    uid => 0,
                    user => "root"
                  }
      )
      allow(Facter::Resolvers::PosixIdentity).to receive(:resolve).with(:user).and_return("root")
      allow(Facter::Resolvers::PosixIdentity).to receive(:resolve).with(:uid).and_return(0)
      allow(Facter::Resolvers::PosixIdentity).to receive(:resolve).with(:gid).and_return(0)
      allow(Facter::Resolvers::PosixIdentity).to receive(:resolve).with(:group).and_return("system")
      allow(Facter::Resolvers::PosixIdentity).to receive(:resolve).with(:privileged).and_return("true")
      allow(Facter::ResolvedFact).to receive(:new).and_return(expected_fact)

      fact = Facter::Aix::Identity.new
      expect(fact.call_the_resolver).to eq(expected_fact)
    end
  end
end
