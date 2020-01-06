# frozen_string_literal: true

describe 'Windows NetworkingIp' do
  context '#call_the_resolver' do
    let(:value) { '0.16.121.255' }
    let(:expected_resolved_fact) { double(Facter::ResolvedFact, name: 'networking.ip', value: value) }
    let(:resolved_legacy_fact) { double(Facter::ResolvedFact, name: 'ipaddress', value: value, type: :legacy) }
    subject(:fact) { Facter::Windows::NetworkingIp.new }

    before do
      expect(Facter::Resolvers::Networking).to receive(:resolve).with(:ip).and_return(value)
      expect(Facter::ResolvedFact).to receive(:new).with('networking.ip', value).and_return(expected_resolved_fact)
      expect(Facter::ResolvedFact).to receive(:new).with('ipaddress', value, :legacy).and_return(resolved_legacy_fact)
    end

    it 'returns ipv4 address fact' do
      expect(fact.call_the_resolver).to eq([expected_resolved_fact, resolved_legacy_fact])
    end
  end
end
