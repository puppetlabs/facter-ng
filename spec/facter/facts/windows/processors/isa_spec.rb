# frozen_string_literal: true

describe 'Windows ProcessorsIsa' do
  context '#call_the_resolver' do
    let(:value) { 'x86_64' }
    let(:expected_resolved_fact) { double(Facter::ResolvedFact, name: 'processors.isa', value: value) }
    let(:resolved_legacy_fact) { double(Facter::ResolvedFact, name: 'hardwareisa', value: value, type: :legacy) }
    subject(:fact) { Facter::Windows::ProcessorsIsa.new }

    before do
      expect(Facter::Resolvers::Processors).to receive(:resolve).with(:isa).and_return(value)
      expect(Facter::ResolvedFact).to receive(:new).with('processors.isa', value).and_return(expected_resolved_fact)
      expect(Facter::ResolvedFact).to receive(:new).with('hardwareisa', value, :legacy).and_return(resolved_legacy_fact)
    end

    it 'returns isa fact' do
      expect(fact.call_the_resolver).to eq([expected_resolved_fact, resolved_legacy_fact])
    end
  end
end
