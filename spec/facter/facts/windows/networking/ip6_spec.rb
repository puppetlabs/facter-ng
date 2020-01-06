# frozen_string_literal: true

describe 'Windows NetworkingIp6' do
  context '#call_the_resolver' do
    let(:value) { 'fe80::5989:97ff:75ae:dae7' }
    let(:expected_resolved_fact) { double(Facter::ResolvedFact, name: 'networking.ip6', value: value) }
    let(:resolved_legacy_fact) { double(Facter::ResolvedFact, name: 'ipaddress6', value: value, type: :legacy) }
    subject(:fact) { Facter::Windows::NetworkingIp6.new }

    before do
      expect(Facter::Resolvers::Networking).to receive(:resolve).with(:ip6).and_return(value)
      expect(Facter::ResolvedFact).to receive(:new).with('networking.ip6', value).and_return(expected_resolved_fact)
      expect(Facter::ResolvedFact).to receive(:new).with('ipaddress6', value, :legacy).and_return(resolved_legacy_fact)
    end

    it 'returns ipv6 address fact' do
      expect(fact.call_the_resolver).to eq([expected_resolved_fact, resolved_legacy_fact])
    end
  end
end
