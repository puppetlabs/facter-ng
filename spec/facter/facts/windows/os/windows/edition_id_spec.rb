# frozen_string_literal: true

describe 'Windows OsWindowsEditionID' do
  context '#call_the_resolver' do
    let(:value) { 'ServerStandard' }
    let(:expected_resolved_fact) { double(Facter::ResolvedFact, name: 'os.windows.edition_id', value: value) }
    let(:resolved_legacy_fact) { double(Facter::ResolvedFact, name: 'windows_edition_id', value: value, type: :legacy) }
    subject(:fact) { Facter::Windows::OsWindowsEditionID.new }

    before do
      expect(Facter::Resolvers::ProductRelease).to receive(:resolve).with(:edition_id).and_return(value)
      expect(Facter::ResolvedFact).to receive(:new).with('os.windows.edition_id', value)
                                                   .and_return(expected_resolved_fact)
      expect(Facter::ResolvedFact).to receive(:new).with('windows_edition_id', value, :legacy)
                                                   .and_return(resolved_legacy_fact)
    end

    it 'returns os edition id fact' do
      expect(fact.call_the_resolver).to eq([expected_resolved_fact, resolved_legacy_fact])
    end
  end
end
