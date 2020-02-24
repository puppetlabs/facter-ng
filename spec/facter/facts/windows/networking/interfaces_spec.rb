# frozen_string_literal: true

describe Facter::Windows::NetworkingInterfaces do
  describe '#call_the_resolver' do
    it 'returns a fact' do
      expected_fact = double(Facter::ResolvedFact, name: 'networking.interfaces', value: 'value')
      allow(Facter::Resolvers::Networking).to receive(:resolve).with(:interfaces).and_return('value')
      allow(Facter::ResolvedFact).to receive(:new).with('networking.interfaces', 'value').and_return(expected_fact)

      fact = Facter::Windows::NetworkingInterfaces.new
      expect(fact.call_the_resolver).to eq(expected_fact)
    end
  end
end
