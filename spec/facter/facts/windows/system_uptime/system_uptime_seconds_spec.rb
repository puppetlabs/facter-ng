# frozen_string_literal: true

describe 'Windows SystemUptimeSeconds' do
  context '#call_the_resolver' do
    let(:value) { '34974' }
    let(:expected_resolved_fact) { double(Facter::ResolvedFact, name: 'system_uptime.seconds', value: value) }
    let(:resolved_legacy_fact) { double(Facter::ResolvedFact, name: 'uptime_seconds', value: value, type: :legacy) }
    subject(:fact) { Facter::Windows::SystemUptimeSeconds.new }

    before do
      expect(Facter::Resolvers::Windows::Uptime).to receive(:resolve).with(:seconds).and_return(value)
      expect(Facter::ResolvedFact).to receive(:new).with('system_uptime.seconds', value)
                                                   .and_return(expected_resolved_fact)
      expect(Facter::ResolvedFact).to receive(:new).with('uptime_seconds', value, :legacy)
                                                   .and_return(resolved_legacy_fact)
    end

    it 'returns seconds since uptime' do
      expect(fact.call_the_resolver).to eq([expected_resolved_fact, resolved_legacy_fact])
    end
  end
end
