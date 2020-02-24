# frozen_string_literal: true

describe 'Windows NetworkingPrimary' do
  describe '#call_the_resolver' do
    it 'returns a fact' do
      expected_fact = double(Facter::ResolvedFact, name: 'networking.primary', value: 'value')
      allow(Facter::Resolvers::Networking).to receive(:resolve).with(:primary).and_return('value')
      allow(Facter::ResolvedFact).to receive(:new).with('networking.primary', 'value').and_return(expected_fact)

      fact = Facter::Windows::NetworkingPrimary.new
      expect(fact.call_the_resolver).to eq(expected_fact)
    end
  end
end
