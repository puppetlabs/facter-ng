# frozen_string_literal: true

describe 'Ubuntu Kernelmajversion' do
  context '#call_the_resolver' do
    let(:value) { '4.15' }

    it 'returns a fact' do
      expected_fact = double(Facter::ResolvedFact, name: 'kernelmajversion', value: value)
      allow(Facter::Resolvers::Uname).to receive(:resolve).with(:kernelrelease).and_return(value)
      allow(Facter::ResolvedFact).to receive(:new).with('kernelmajversion', value).and_return(expected_fact)

      fact = Facter::Ubuntu::Kernelmajversion.new
      expect(fact.call_the_resolver).to eq(expected_fact)
    end
  end
end
