# frozen_string_literal: true

describe 'Windows NetworkingNetwork6' do
  context '#call_the_resolver' do
    let(:value) { 'fe80::' }
    let(:expected_resolved_fact) { double(Facter::ResolvedFact, name: 'networking.network6', value: value) }
    let(:resolved_legacy_fact) { double(Facter::ResolvedFact, name: 'network6', value: value, type: :legacy) }
    subject(:fact) { Facter::Windows::NetworkingNetwork6.new }

    before do
      expect(Facter::Resolvers::Networking).to receive(:resolve).with(:network6).and_return(value)
      expect(Facter::ResolvedFact).to receive(:new).with('networking.network6', value)
                                                   .and_return(expected_resolved_fact)
      expect(Facter::ResolvedFact).to receive(:new).with('network6', value, :legacy).and_return(resolved_legacy_fact)
    end

    it 'returns network ipv6 fact' do
      expect(fact.call_the_resolver).to eq([expected_resolved_fact, resolved_legacy_fact])
    end
  end
end
