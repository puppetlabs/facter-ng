# frozen_string_literal: true

describe 'Windows NetworkingNetmask6' do
  context '#call_the_resolver' do
    let(:value) { 'ffff:ffff:ffff:ffff::' }
    let(:expected_resolved_fact) { double(Facter::ResolvedFact, name: 'networking.netmask6', value: value) }
    let(:resolved_legacy_fact) { double(Facter::ResolvedFact, name: 'netmask6', value: value, type: :legacy) }
    subject(:fact) { Facter::Windows::NetworkingNetmask6.new }

    before do
      expect(Facter::Resolvers::Networking).to receive(:resolve).with(:netmask6).and_return(value)
      expect(Facter::ResolvedFact).to receive(:new).with('networking.netmask6', value)
                                                   .and_return(expected_resolved_fact)
      expect(Facter::ResolvedFact).to receive(:new).with('netmask6', value, :legacy).and_return(resolved_legacy_fact)
    end

    it 'returns netmask for ipv6 ip address fact' do
      expect(fact.call_the_resolver).to eq([expected_resolved_fact, resolved_legacy_fact])
    end
  end
end
