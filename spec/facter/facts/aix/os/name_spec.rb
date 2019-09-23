# frozen_string_literal: true

describe 'AIX OsName' do
  context '#call_the_resolver' do
    it 'returns a fact' do
      expected_fact = double(Facter::ResolvedFact, name: 'os.name', value: 'value')
      allow(Facter::Resolvers::UnameResolver).to receive(:resolve).with(:kernelname).and_return('value')
      allow(Facter::ResolvedFact).to receive(:new).with('os.name', 'value').and_return(expected_fact)

      fact = Facter::Aix::OsName.new
      expect(fact.call_the_resolver).to eq(expected_fact)
    end
  end
end
