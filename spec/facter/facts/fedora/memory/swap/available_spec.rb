# frozen_string_literal: true

describe 'Fedora MemorySwapAvailable' do
  context '#call_the_resolver' do
    it 'returns a fact' do
      expected_fact = double(Facter::ResolvedFact, name: 'memory.swap.available', value: 'value')
      allow(Facter::Resolvers::Linux::Memory).to receive(:resolve).with(:swap_free).and_return('value')
      allow(Facter::ResolvedFact).to receive(:new).with('memory.swap.available', 'value').and_return(expected_fact)

      fact = Facter::Fedora::MemorySwapAvailable.new
      expect(fact.call_the_resolver).to eq(expected_fact)
    end
  end
end
