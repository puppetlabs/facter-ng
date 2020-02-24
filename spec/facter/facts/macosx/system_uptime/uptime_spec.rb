# frozen_string_literal: true

describe 'Macosx SystemUptimeUptime' do
  describe '#call_the_resolver' do
    let(:value) { '10 days' }

    it 'returns a fact' do
      expected_fact = double(Facter::ResolvedFact, name: 'system_uptime.uptime', value: value)
      allow(Facter::Resolvers::Uptime).to receive(:resolve).with(:uptime).and_return(value)
      allow(Facter::ResolvedFact).to receive(:new).with('system_uptime.uptime', value).and_return(expected_fact)

      fact = Facter::Macosx::SystemUptimeUptime.new
      expect(fact.call_the_resolver).to eq(expected_fact)
    end
  end
end
