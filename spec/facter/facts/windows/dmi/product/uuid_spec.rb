# frozen_string_literal: true

describe 'Windows DmiProductUUID' do
  context '#call_the_resolver' do
    let(:value) { '030D1A42-B70A-2898-7898-5E85A0AD1847' }
    let(:expected_resolved_fact) { double(Facter::ResolvedFact, name: 'dmi.product.uuid', value: value) }
    let(:resolved_legacy_fact) { double(Facter::ResolvedFact, name: 'uuid', value: value, type: :legacy) }
    subject(:fact) { Facter::Windows::DmiProductUUID.new }

    before do
      expect(Facter::Resolvers::DMIComputerSystem).to receive(:resolve).with(:uuid).and_return(value)
      expect(Facter::ResolvedFact).to receive(:new).with('dmi.product.uuid', value)
                                                   .and_return(expected_resolved_fact)
      expect(Facter::ResolvedFact).to receive(:new).with('uuid', value, :legacy)
                                                   .and_return(resolved_legacy_fact)
    end

    it 'returns product uuid fact' do
      expect(fact.call_the_resolver).to eq([expected_resolved_fact, resolved_legacy_fact])
    end
  end
end
