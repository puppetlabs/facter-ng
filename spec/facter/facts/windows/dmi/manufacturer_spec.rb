# frozen_string_literal: true

describe 'Windows DmiManufacturer' do
  context '#call_the_resolver' do
    let(:value) { 'VMware, Inc.' }
    let(:expected_resolved_fact) { double(Facter::ResolvedFact, name: 'dmi.manufacturer', value: value) }
    let(:resolved_legacy_fact) { double(Facter::ResolvedFact, name: 'manufacturer', value: value, type: :legacy) }
    subject(:fact) { Facter::Windows::DmiManufacturer.new }

    before do
      expect(Facter::Resolvers::DMIBios).to receive(:resolve).with(:manufacturer).and_return(value)
      expect(Facter::ResolvedFact).to receive(:new).with('dmi.manufacturer', value).and_return(expected_resolved_fact)
      expect(Facter::ResolvedFact).to receive(:new).with('manufacturer', value, :legacy)
                                                   .and_return(resolved_legacy_fact)
    end

    it 'returns manufacturer fact' do
      expect(fact.call_the_resolver).to eq([expected_resolved_fact, resolved_legacy_fact])
    end
  end
end
