# frozen_string_literal: true

describe 'Windows SystemUptimeUptime' do
  context '#call_the_resolver' do
    let(:value) { '9:42 hours' }
    let(:expected_resolved_fact) { double(Facter::ResolvedFact, name: 'system_uptime.uptime', value: value) }
    let(:resolved_legacy_fact) { double(Facter::ResolvedFact, name: 'uptime', value: value, type: :legacy) }
    subject(:fact) { Facter::Windows::SystemUptimeUptime.new }

    before do
      expect(Facter::Resolvers::Windows::Uptime).to receive(:resolve).with(:uptime).and_return(value)
      expect(Facter::ResolvedFact).to receive(:new).with('system_uptime.uptime', value)
                                                   .and_return(expected_resolved_fact)
      expect(Facter::ResolvedFact).to receive(:new).with('uptime', value, :legacy).and_return(resolved_legacy_fact)
    end

    it 'returns uptime fact' do
      expect(fact.call_the_resolver).to eq([expected_resolved_fact, resolved_legacy_fact])
    end
  end
end
