# frozen_string_literal: true

describe 'Windows NetworkingNetmask' do
  context '#call_the_resolver' do
    let(:value) { '255.255.240.0' }
    let(:expected_resolved_fact) { double(Facter::ResolvedFact, name: 'networking.netmask', value: value) }
    let(:resolved_legacy_fact) { double(Facter::ResolvedFact, name: 'netmask', value: value, type: :legacy) }
    subject(:fact) { Facter::Windows::NetworkingNetmask.new }

    before do
      expect(Facter::Resolvers::Networking).to receive(:resolve).with(:netmask).and_return(value)
      expect(Facter::ResolvedFact).to receive(:new).with('networking.netmask', value).and_return(expected_resolved_fact)
      expect(Facter::ResolvedFact).to receive(:new).with('netmask', value, :legacy).and_return(resolved_legacy_fact)
    end

    it 'returns netmask for ipv4 ip address fact' do
      expect(fact.call_the_resolver).to eq([expected_resolved_fact, resolved_legacy_fact])
    end
  end
end
