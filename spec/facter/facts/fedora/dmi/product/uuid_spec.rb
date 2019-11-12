# frozen_string_literal: true

describe 'Fedora DmiProductUuid' do
  context '#call_the_resolver' do
    it 'returns a fact' do
      expected_fact = double(Facter::ResolvedFact, name: 'dmi.product.uuid', value: 'value')
      allow(Facter::Resolvers::Linux::DmiBios).to receive(:resolve).with(:product_uuid).and_return('value')
      allow(Facter::ResolvedFact).to receive(:new).with('dmi.product.uuid', 'value').and_return(expected_fact)

      fact = Facter::Fedora::DmiProductUuid.new
      expect(fact.call_the_resolver).to eq(expected_fact)
    end
  end
end
