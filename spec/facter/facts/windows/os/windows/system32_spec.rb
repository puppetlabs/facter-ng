# frozen_string_literal: true

describe 'Windows OsWindowsSystem32' do
  context '#call_the_resolver' do
    let(:value) { 'C:\Windows\system32' }
    let(:expected_resolved_fact) { double(Facter::ResolvedFact, name: 'os.windows.system32', value: value) }
    let(:resolved_legacy_fact) do
      double(Facter::ResolvedFact, name: 'system32',
                                   value: value, type: :legacy)
    end
    subject(:fact) { Facter::Windows::OsWindowsSystem32.new }

    before do
      expect(Facter::Resolvers::System32).to receive(:resolve).with(:system32).and_return(value)
      expect(Facter::ResolvedFact).to receive(:new).with('os.windows.system32', value)
                                                   .and_return(expected_resolved_fact)
      expect(Facter::ResolvedFact).to receive(:new).with('system32', value, :legacy)
                                                   .and_return(resolved_legacy_fact)
    end

    it 'returns system32 path' do
      expect(fact.call_the_resolver).to eq([expected_resolved_fact, resolved_legacy_fact])
    end
  end
end
