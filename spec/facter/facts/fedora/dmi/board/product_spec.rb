# frozen_string_literal: true

describe 'Fedora DmiBoardProduct' do
  context '#call_the_resolver' do
    it 'returns a fact' do
      expected_fact = double(Facter::ResolvedFact, name: 'dmi.board.product', value: 'value')
      allow(Facter::Resolvers::Linux::DmiBios).to receive(:resolve).with(:board_name).and_return('value')
      allow(Facter::ResolvedFact).to receive(:new).with('dmi.board.product', 'value').and_return(expected_fact)

      fact = Facter::Fedora::DmiBoardProduct.new
      expect(fact.call_the_resolver).to eq(expected_fact)
    end
  end
end
