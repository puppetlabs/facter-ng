# frozen_string_literal: true

describe 'Windows ProcessorsCount' do
  context '#call_the_resolver' do
    let(:value) { '2' }
    let(:expected_resolved_fact) { double(Facter::ResolvedFact, name: 'processors.count', value: value) }
    let(:resolved_legacy_fact) { double(Facter::ResolvedFact, name: 'processorcount', value: value, type: :legacy) }
    subject(:fact) { Facter::Windows::ProcessorsCount.new }

    before do
      expect(Facter::Resolvers::Processors).to receive(:resolve).with(:count).and_return(value)
      expect(Facter::ResolvedFact).to receive(:new).with('processors.count', value).and_return(expected_resolved_fact)
      expect(Facter::ResolvedFact).to receive(:new).with('processorcount', value, :legacy)
                                                   .and_return(resolved_legacy_fact)
    end

    it 'returns number of processors' do
      expect(fact.call_the_resolver).to eq([expected_resolved_fact, resolved_legacy_fact])
    end
  end
end
