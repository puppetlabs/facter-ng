# frozen_string_literal: true

describe 'Windows OsFamily' do
  context '#call_the_resolver' do
    let(:value) { 'windows' }
    let(:expected_resolved_fact) { double(Facter::ResolvedFact, name: 'os.family', value: value) }
    let(:resolved_legacy_fact) { double(Facter::ResolvedFact, name: 'osfamily', value: value, type: :legacy) }
    subject(:fact) { Facter::Windows::OsFamily.new }

    before do
      expect(Facter::Resolvers::Kernel).to receive(:resolve).with(:kernel).and_return(value)
      expect(Facter::ResolvedFact).to receive(:new).with('os.family', value).and_return(expected_resolved_fact)
      expect(Facter::ResolvedFact).to receive(:new).with('osfamily', value, :legacy).and_return(resolved_legacy_fact)
    end

    it 'returns os family fact' do
      expect(fact.call_the_resolver).to eq([expected_resolved_fact, resolved_legacy_fact])
    end
  end
end
