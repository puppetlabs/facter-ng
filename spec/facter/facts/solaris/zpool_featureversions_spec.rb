# frozen_string_literal: true

describe 'Solaris ZPool feature numbers' do
  context '#call_the_resolver' do
    subject(:call_the_resolver) { Facter::Solaris::ZPoolFeatureNumbers.new.call_the_resolver }
    let(:zpool_featurenumbers) { '1,2,3,4,5,6,7' }

    before do
      allow(Facter::Resolvers::Solaris::ZPool).to \
        receive(:resolve).with(:zpool_featurenumbers).and_return(zpool_featurenumbers)
    end

    it 'calls Facter::Resolvers::Solaris::ZPool' do
      call_the_resolver
      expect(Facter::Resolvers::Solaris::ZPool).to have_received(:resolve).with(:zpool_featurenumbers)
    end

    it 'returns the zpool_featurenumbers fact' do
      expect(call_the_resolver).to be_an_instance_of(Facter::ResolvedFact).and \
        have_attributes(name: 'zpool_featurenumbers', value: zpool_featurenumbers)
    end
  end
end
