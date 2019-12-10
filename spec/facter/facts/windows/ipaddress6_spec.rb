# frozen_string_literal: true

describe 'Windows Ipaddress6' do
  context '#call_the_resolver' do
    it 'returns a fact' do
      expected_fact = double(Facter::ResolvedFact, name: 'ipaddress6', value: 'fe80::7ca0:ab22:703a:b329')
      allow(Facter::Resolvers::Networking).to receive(:resolve).with(:ip6).and_return('fe80::7ca0:ab22:703a:b329')
      allow(Facter::ResolvedFact).to receive(:new).with('ipaddress6', 'fe80::7ca0:ab22:703a:b329')
                                                  .and_return(expected_fact)

      fact = Facter::Windows::Ipaddress6.new
      expect(fact.call_the_resolver).to eq(expected_fact)
    end
  end
end
