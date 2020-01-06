# frozen_string_literal: true

describe 'Windows SystemUptimeDays' do
  context '#call_the_resolver' do
    let(:value) { '2' }
    let(:expected_resolved_fact) { double(Facter::ResolvedFact, name: 'system_uptime.days', value: value) }
    let(:resolved_legacy_fact) { double(Facter::ResolvedFact, name: 'uptime_days', value: value, type: :legacy) }
    subject(:fact) { Facter::Windows::SystemUptimeDays.new }

    before do
      expect(Facter::Resolvers::Windows::Uptime).to receive(:resolve).with(:days).and_return(value)
      expect(Facter::ResolvedFact).to receive(:new).with('system_uptime.days', value).and_return(expected_resolved_fact)
      expect(Facter::ResolvedFact).to receive(:new).with('uptime_days', value, :legacy).and_return(resolved_legacy_fact)
    end

    it 'returns days since uptime' do
      expect(fact.call_the_resolver).to eq([expected_resolved_fact, resolved_legacy_fact])
    end
  end
end
