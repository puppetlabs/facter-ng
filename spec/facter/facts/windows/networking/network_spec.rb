# frozen_string_literal: true

describe 'Windows NetworkingNetwork' do
  context '#call_the_resolver' do
    let(:value) { '10.16.112.0' }
    let(:expected_resolved_fact) { double(Facter::ResolvedFact, name: 'networking.network', value: value) }
    let(:resolved_legacy_fact) { double(Facter::ResolvedFact, name: 'network', value: value, type: :legacy) }
    subject(:fact) { Facter::Windows::NetworkingNetwork.new }

    before do
      expect(Facter::Resolvers::Networking).to receive(:resolve).with(:network).and_return(value)
      expect(Facter::ResolvedFact).to receive(:new).with('networking.network', value).and_return(expected_resolved_fact)
      expect(Facter::ResolvedFact).to receive(:new).with('network', value, :legacy).and_return(resolved_legacy_fact)
    end

    it 'returns network ipv4 fact' do
      expect(fact.call_the_resolver).to eq([expected_resolved_fact, resolved_legacy_fact])
    end
  end
end
