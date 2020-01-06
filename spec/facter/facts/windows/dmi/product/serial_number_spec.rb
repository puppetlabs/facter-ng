# frozen_string_literal: true

describe 'Windows DmiProductSerialNumber' do
  context '#call_the_resolver' do
    let(:value) { 'VMware-42 1a 0d 03 0a b7 98 28-78 98 5e 85 a0 ad 18 47' }
    let(:expected_resolved_fact) { double(Facter::ResolvedFact, name: 'dmi.product.serial_number', value: value) }
    let(:resolved_legacy_fact) { double(Facter::ResolvedFact, name: 'serialnumber', value: value, type: :legacy) }
    subject(:fact) { Facter::Windows::DmiProductSerialNumber.new }

    before do
      expect(Facter::Resolvers::DMIBios).to receive(:resolve).with(:serial_number).and_return(value)
      expect(Facter::ResolvedFact).to receive(:new).with('dmi.product.serial_number', value)
                                                   .and_return(expected_resolved_fact)
      expect(Facter::ResolvedFact).to receive(:new).with('serialnumber', value, :legacy)
                                                   .and_return(resolved_legacy_fact)
    end

    it 'returns serial_number fact' do
      expect(fact.call_the_resolver).to eq([expected_resolved_fact, resolved_legacy_fact])
    end
  end
end
