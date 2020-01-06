# frozen_string_literal: true

describe 'Windows OsWindowsInstallationType' do
  context '#call_the_resolver' do
    let(:value) { 'Server' }
    let(:expected_resolved_fact) { double(Facter::ResolvedFact, name: 'os.windows.installation_type', value: value) }
    let(:resolved_legacy_fact) do
      double(Facter::ResolvedFact, name: 'windows_installation_type',
                                   value: value, type: :legacy)
    end
    subject(:fact) { Facter::Windows::OsWindowsInstallationType.new }

    before do
      expect(Facter::Resolvers::ProductRelease).to receive(:resolve).with(:installation_type).and_return(value)
      expect(Facter::ResolvedFact).to receive(:new).with('os.windows.installation_type', value)
                                                   .and_return(expected_resolved_fact)
      expect(Facter::ResolvedFact).to receive(:new).with('windows_installation_type', value, :legacy)
                                                   .and_return(resolved_legacy_fact)
    end

    it 'returns os installation type fact' do
      expect(fact.call_the_resolver).to eq([expected_resolved_fact, resolved_legacy_fact])
    end
  end
end
