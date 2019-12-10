# frozen_string_literal: true

describe 'Windows Network6' do
  context '#call_the_resolver' do
    it 'returns a fact' do
      expected_fact = double(Facter::ResolvedFact, name: 'network6', value: 'ffff:ffff:ffff:ffff::')
      allow(Facter::Resolvers::Networking).to receive(:resolve).with(:network6).and_return('ffff:ffff:ffff:ffff::')
      allow(Facter::ResolvedFact).to receive(:new).with('network6', 'ffff:ffff:ffff:ffff::').and_return(expected_fact)

      fact = Facter::Windows::Network6.new
      expect(fact.call_the_resolver).to eq(expected_fact)
    end
  end
end
