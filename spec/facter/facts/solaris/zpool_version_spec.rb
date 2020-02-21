# frozen_string_literal: true

describe 'Solaris ZPool version' do
  context '#call_the_resolver' do
    subject(:call_the_resolver) { Facter::Solaris::ZPoolVersion.new.call_the_resolver }
    let(:version) { '5' }

    before do
      allow(Facter::Resolvers::Solaris::ZPool).to receive(:resolve).with(:zpool_version).and_return(version)
    end

    it 'calls Facter::Resolvers::Solaris::ZPool' do
      call_the_resolver
      expect(Facter::Resolvers::Solaris::ZPool).to have_received(:resolve).with(:zpool_version)
    end

    it 'returns the ZPool version fact' do
      expect(call_the_resolver).to be_an_instance_of(Facter::ResolvedFact).and \
        have_attributes(name: 'zpool_version', value: version)
    end
  end
end
