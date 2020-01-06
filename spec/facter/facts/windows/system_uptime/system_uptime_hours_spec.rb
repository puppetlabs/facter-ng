# frozen_string_literal: true

describe 'Windows SystemUptimeHours' do
  context '#call_the_resolver' do
    let(:value) { '9' }
    let(:expected_resolved_fact) { double(Facter::ResolvedFact, name: 'system_uptime.hours', value: value) }
    let(:resolved_legacy_fact) { double(Facter::ResolvedFact, name: 'uptime_hours', value: value, type: :legacy) }
    subject(:fact) { Facter::Windows::SystemUptimeHours.new }

    before do
      expect(Facter::Resolvers::Windows::Uptime).to receive(:resolve).with(:hours).and_return(value)
      expect(Facter::ResolvedFact).to receive(:new).with('system_uptime.hours', value)
                                                   .and_return(expected_resolved_fact)
      expect(Facter::ResolvedFact).to receive(:new).with('uptime_hours', value, :legacy)
                                                   .and_return(resolved_legacy_fact)
    end

    it 'returns hours since uptime' do
      expect(fact.call_the_resolver).to eq([expected_resolved_fact, resolved_legacy_fact])
    end
  end
end
