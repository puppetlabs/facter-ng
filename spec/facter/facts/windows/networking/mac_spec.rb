# frozen_string_literal: true

describe 'Windows NetworkingMac' do
  context '#call_the_resolver' do
    let(:value) { '00:50:56:9A:7E:98' }
    let(:expected_resolved_fact) { double(Facter::ResolvedFact, name: 'networking.mac', value: value) }
    let(:resolved_legacy_fact) { double(Facter::ResolvedFact, name: 'macaddress', value: value, type: :legacy) }
    subject(:fact) { Facter::Windows::NetworkingMac.new }

    before do
      expect(Facter::Resolvers::Networking).to receive(:resolve).with(:mac).and_return(value)
      expect(Facter::ResolvedFact).to receive(:new).with('networking.mac', value).and_return(expected_resolved_fact)
      expect(Facter::ResolvedFact).to receive(:new).with('macaddress', value, :legacy).and_return(resolved_legacy_fact)
    end

    it 'returns mac address fact' do
      expect(fact.call_the_resolver).to eq([expected_resolved_fact, resolved_legacy_fact])
    end
  end
end
