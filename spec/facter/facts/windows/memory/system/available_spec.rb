# frozen_string_literal: true

describe 'Windows MemorySystemAvailable' do
  context '#call_the_resolver' do
    let(:value) { '1.0 KiB' }
    let(:expected_resolved_fact) { double(Facter::ResolvedFact, name: 'memory.system.available', value: value) }
    let(:resolved_legacy_fact) { double(Facter::ResolvedFact, name: 'memoryfree', value: value, type: :legacy) }
    subject(:fact) { Facter::Windows::MemorySystemAvailable.new }

    before do
      expect(Facter::Resolvers::Memory).to receive(:resolve).with(:available_bytes).and_return(1024)
      expect(Facter::BytesToHumanReadable.convert(1024)).to eq(value)
      expect(Facter::ResolvedFact).to receive(:new).with('memory.system.available', value)
                                                   .and_return(expected_resolved_fact)
      expect(Facter::ResolvedFact).to receive(:new).with('memoryfree', value, :legacy).and_return(resolved_legacy_fact)
    end

    it 'returns free memory fact' do
      expect(fact.call_the_resolver).to eq([expected_resolved_fact, resolved_legacy_fact])
    end
  end
end
