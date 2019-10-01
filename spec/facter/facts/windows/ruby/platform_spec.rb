# frozen_string_literal: true

describe 'Windows RubyPlatform' do
  context '#call_the_resolver' do
    it 'returns a fact' do
      expected_fact = double(Facter::ResolvedFact, name: 'ruby.platform', value: 'value')
      allow(Facter::Resolvers::Ruby).to receive(:resolve).with(:platform).and_return('value')
      allow(Facter::ResolvedFact).to receive(:new).with('ruby.platform', 'value').and_return(expected_fact)

      fact = Facter::Windows::RubyPlatform.new
      expect(fact.call_the_resolver).to eq(expected_fact)
    end
  end
end
