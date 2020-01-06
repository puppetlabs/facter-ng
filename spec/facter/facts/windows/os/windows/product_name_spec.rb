# frozen_string_literal: true

describe 'Windows OsWindowsProductName' do
  context '#call_the_resolver' do
    let(:value) { 'Windows Server 2016 Standard' }
    let(:expected_resolved_fact) { double(Facter::ResolvedFact, name: 'os.windows.product_name', value: value) }
    let(:resolved_legacy_fact) do
      double(Facter::ResolvedFact, name: 'windows_product_name',
                                   value: value, type: :legacy)
    end
    subject(:fact) { Facter::Windows::OsWindowsProductName.new }

    before do
      expect(Facter::Resolvers::ProductRelease).to receive(:resolve).with(:product_name).and_return(value)
      expect(Facter::ResolvedFact).to receive(:new).with('os.windows.product_name', value)
                                                   .and_return(expected_resolved_fact)
      expect(Facter::ResolvedFact).to receive(:new).with('windows_product_name', value, :legacy)
                                                   .and_return(resolved_legacy_fact)
    end

    it 'returns os product name fact' do
      expect(fact.call_the_resolver).to eq([expected_resolved_fact, resolved_legacy_fact])
    end
  end
end
