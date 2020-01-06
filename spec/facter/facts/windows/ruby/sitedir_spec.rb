# frozen_string_literal: true

describe 'Windows RubySitedir' do
  context '#call_the_resolver' do
    let(:value) { 'C:/Program Files/Puppet Labs/Puppet/puppet/lib/ruby/site_ruby/2.5.0' }
    let(:expected_resolved_fact) { double(Facter::ResolvedFact, name: 'ruby.sitedir', value: value) }
    let(:resolved_legacy_fact) { double(Facter::ResolvedFact, name: 'rubysitedir', value: value, type: :legacy) }
    subject(:fact) { Facter::Windows::RubySitedir.new }

    before do
      expect(Facter::Resolvers::Ruby).to receive(:resolve).with(:sitedir).and_return(value)
      expect(Facter::ResolvedFact).to receive(:new).with('ruby.sitedir', value).and_return(expected_resolved_fact)
      expect(Facter::ResolvedFact).to receive(:new).with('rubysitedir', value, :legacy).and_return(resolved_legacy_fact)
    end

    it 'returns ruby sitedir fact' do
      expect(fact.call_the_resolver).to eq([expected_resolved_fact, resolved_legacy_fact])
    end
  end
end
