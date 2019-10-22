# frozen_string_literal: true

describe 'Fedora MemorySystemTotal' do
  context '#call_the_resolver' do
    it 'returns a fact' do
      expected_fact = double(Facter::ResolvedFact, name: 'memory.system.total', value: 'value')
      allow(Facter::Resolvers::Linux::Memory).to receive(:resolve).with(:total).and_return('value')
      allow(Facter::ResolvedFact).to receive(:new).with('memory.system.total', 'value').and_return(expected_fact)

      fact = Facter::Fedora::MemorySystemTotal.new
      expect(fact.call_the_resolver).to eq(expected_fact)
    end
  end
end
