# frozen_string_literal: true

describe 'Solaris ZPool' do
  context '#call_the_resolver' do
    it 'returns zpool_version fact' do
      expected_fact = double(Facter::ResolvedFact, name: 'zpool_version', value: '44')
      allow(Facter::Resolvers::Solaris::ZPool).to receive(:resolve).with('zpool_version').and_return(44)
      allow(Facter::ResolvedFact).to receive(:new).with('zpool_version', '44').and_return(expected_fact)
    end

    it 'returns zpool_featurenumbers fact' do
      expected_fact = double(Facter::ResolvedFact, name: 'zpool_featurenumbers', value: '1,2,3,4,5,6,7')
      allow(Facter::Resolvers::Solaris::ZPool).to receive(:resolve)
        .with('zpool_featurenumbers')
        .and_return('1,2,3,4,5,6,7')
      allow(Facter::ResolvedFact).to receive(:new)
        .with('zpool_feature', '1,2,3,4,5,6,7')
        .and_return(expected_fact)
    end
  end
end
