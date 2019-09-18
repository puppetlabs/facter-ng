# frozen_string_literal: true

describe 'Windows MemorySystemAvailable' do
  context '#call_the_resolver' do
    it 'returns a fact' do
      expected_fact = double(Facter::ResolvedFact, name: 'memory.system.available', value: '1.0 KiB')
      allow(MemoryResolver).to receive(:resolve).with(:available_bytes).and_return(1024)
      allow(Facter::ResolvedFact).to receive(:new).with('memory.system.available', '1.0 KiB').and_return(expected_fact)

      fact = Facter::Windows::MemorySystemAvailable.new
      expect(Facter::BytesToHumanReadable.convert(1024)).to eq('1.0 KiB')
      expect(fact.call_the_resolver).to eq(expected_fact)
    end
  end
end
