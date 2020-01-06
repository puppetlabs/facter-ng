# frozen_string_literal: true

describe 'Windows OsWindowsReleaseID' do
  context '#call_the_resolver' do
    let(:value) { '1607' }
    let(:expected_resolved_fact) { double(Facter::ResolvedFact, name: 'os.windows.release_id', value: value) }
    let(:resolved_legacy_fact) do
      double(Facter::ResolvedFact, name: 'windows_release_id',
                                   value: value, type: :legacy)
    end
    subject(:fact) { Facter::Windows::OsWindowsReleaseID.new }

    before do
      expect(Facter::Resolvers::ProductRelease).to receive(:resolve).with(:release_id).and_return(value)
      expect(Facter::ResolvedFact).to receive(:new).with('os.windows.release_id', value)
                                                   .and_return(expected_resolved_fact)
      expect(Facter::ResolvedFact).to receive(:new).with('windows_release_id', value, :legacy)
                                                   .and_return(resolved_legacy_fact)
    end

    it 'returns os release id fact' do
      expect(fact.call_the_resolver).to eq([expected_resolved_fact, resolved_legacy_fact])
    end
  end
end
