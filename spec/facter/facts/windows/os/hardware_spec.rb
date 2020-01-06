# frozen_string_literal: true

describe 'Windows OsHardware' do
  context '#call_the_resolver' do
    let(:value) { 'x86_64' }
    let(:expected_resolved_fact) { double(Facter::ResolvedFact, name: 'os.hardware', value: value) }
    let(:resolved_legacy_fact) { double(Facter::ResolvedFact, name: 'hardwaremodel', value: value, type: :legacy) }
    subject(:fact) { Facter::Windows::OsHardware.new }

    before do
      expect(Facter::Resolvers::HardwareArchitecture).to receive(:resolve).with(:hardware).and_return(value)
      expect(Facter::ResolvedFact).to receive(:new).with('os.hardware', value).and_return(expected_resolved_fact)
      expect(Facter::ResolvedFact).to receive(:new).with('hardwaremodel', value, :legacy)
                                                   .and_return(resolved_legacy_fact)
    end

    it 'returns harware model fact' do
      expect(fact.call_the_resolver).to eq([expected_resolved_fact, resolved_legacy_fact])
    end
  end
end
