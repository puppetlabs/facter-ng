# frozen_string_literal: true

describe 'Windows NetworkingDomain' do
  context '#call_the_resolver' do
    let(:value) { 'domain.net' }
    let(:expected_resolved_fact) { double(Facter::ResolvedFact, name: 'networking.domain', value: value) }
    let(:resolved_legacy_fact) { double(Facter::ResolvedFact, name: 'domain', value: value, type: :legacy) }
    subject(:fact) { Facter::Windows::NetworkingDomain.new }

    before do
      expect(Facter::Resolvers::Networking).to receive(:resolve).with(:domain).and_return(value)
      expect(Facter::ResolvedFact).to receive(:new).with('networking.domain', value).and_return(expected_resolved_fact)
      expect(Facter::ResolvedFact).to receive(:new).with('domain', value, :legacy).and_return(resolved_legacy_fact)
    end

    it 'returns domain fact' do
      expect(fact.call_the_resolver).to eq([expected_resolved_fact, resolved_legacy_fact])
    end
  end
end
