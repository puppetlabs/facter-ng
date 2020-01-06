# frozen_string_literal: true

describe 'Windows RubyPlatform' do
  context '#call_the_resolver' do
    let(:value) { 'x64-mingw32' }
    let(:expected_resolved_fact) { double(Facter::ResolvedFact, name: 'ruby.platform', value: value) }
    let(:resolved_legacy_fact) { double(Facter::ResolvedFact, name: 'rubyplatform', value: value, type: :legacy) }
    subject(:fact) { Facter::Windows::RubyPlatform.new }

    before do
      expect(Facter::Resolvers::Ruby).to receive(:resolve).with(:platform).and_return(value)
      expect(Facter::ResolvedFact).to receive(:new).with('ruby.platform', value).and_return(expected_resolved_fact)
      expect(Facter::ResolvedFact).to receive(:new).with('rubyplatform', value, :legacy)
                                                   .and_return(resolved_legacy_fact)
    end

    it 'returns ruby platform fact' do
      expect(fact.call_the_resolver).to eq([expected_resolved_fact, resolved_legacy_fact])
    end
  end
end
