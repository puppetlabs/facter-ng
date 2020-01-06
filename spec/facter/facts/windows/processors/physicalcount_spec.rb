# frozen_string_literal: true

describe 'Windows ProcessorsPhysicalcount' do
  context '#call_the_resolver' do
    let(:value) { '2' }
    let(:expected_resolved_fact) { double(Facter::ResolvedFact, name: 'processors.physicalcount', value: value) }
    let(:resolved_legacy_fact) do
      double(Facter::ResolvedFact, name: 'physicalprocessorcount', value: value,
                                   type: :legacy)
    end
    subject(:fact) { Facter::Windows::ProcessorsPhysicalcount.new }

    before do
      expect(Facter::Resolvers::Processors).to receive(:resolve).with(:physicalcount).and_return(value)
      expect(Facter::ResolvedFact).to receive(:new).with('processors.physicalcount', value)
                                                   .and_return(expected_resolved_fact)
      expect(Facter::ResolvedFact).to receive(:new).with('physicalprocessorcount', value, :legacy)
                                                   .and_return(resolved_legacy_fact)
    end

    it 'returns number of physical processors' do
      expect(fact.call_the_resolver).to eq([expected_resolved_fact, resolved_legacy_fact])
    end
  end
end
