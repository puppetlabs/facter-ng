# frozen_string_literal: true

describe 'Windows RubyVersion' do
  context '#call_the_resolver' do
    let(:value) { '2.5.7' }
    let(:expected_resolved_fact) { double(Facter::ResolvedFact, name: 'ruby.version', value: value) }
    let(:resolved_legacy_fact) { double(Facter::ResolvedFact, name: 'rubyversion', value: value, type: :legacy) }
    subject(:fact) { Facter::Windows::RubyVersion.new }

    before do
      expect(Facter::Resolvers::Ruby).to receive(:resolve).with(:version).and_return(value)
      expect(Facter::ResolvedFact).to receive(:new).with('ruby.version', value).and_return(expected_resolved_fact)
      expect(Facter::ResolvedFact).to receive(:new).with('rubyversion', value, :legacy).and_return(resolved_legacy_fact)
    end

    it 'returns ruby version' do
      expect(fact.call_the_resolver).to eq([expected_resolved_fact, resolved_legacy_fact])
    end
  end
end
