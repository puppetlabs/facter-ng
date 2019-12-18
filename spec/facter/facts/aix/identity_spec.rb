# frozen_string_literal: true

describe 'Aix Identity' do
  context '#call_the_resolver' do
    it 'returns a fact' do
      expected_fact = double(Facter::ResolvedFact, name: 'identity', value: 'value')
      allow(<resolver_name>).to receive(:resolve).with(<resolver_fact>).and_return('value')
      allow(Facter::ResolvedFact).to receive(:new).with('identity', 'value').and_return(expected_fact)

      fact = Facter::Aix::Identity.new
      expect(fact.call_the_resolver).to eq(expected_fact)
    end
  end
end
