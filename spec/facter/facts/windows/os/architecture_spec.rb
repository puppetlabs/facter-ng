# frozen_string_literal: true

describe 'Windows OsArchitecture' do
  context '#call_the_resolver' do
    let(:value) { 'x64' }
    let(:expected_resolved_fact) { double(Facter::ResolvedFact, name: 'os.architecture', value: value) }
    let(:resolved_legacy_fact) { double(Facter::ResolvedFact, name: 'architecture', value: value, type: :legacy) }
    subject(:fact) { Facter::Windows::OsArchitecture.new }

    before do
      expect(Facter::Resolvers::HardwareArchitecture).to receive(:resolve).with(:architecture).and_return(value)
      expect(Facter::ResolvedFact).to receive(:new).with('os.architecture', value).and_return(expected_resolved_fact)
      expect(Facter::ResolvedFact).to receive(:new).with('architecture', value, :legacy)
                                                   .and_return(resolved_legacy_fact)
    end

    it 'returns architecture fact' do
      expect(fact.call_the_resolver).to eq([expected_resolved_fact, resolved_legacy_fact])
    end
  end
end
