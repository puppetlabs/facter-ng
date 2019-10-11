# frozen_string_literal: true

describe 'Windows SystemUptimeUptime' do
  context '#call_the_resolver' do
    it 'returns a fact' do
      expected_fact = double(Facter::ResolvedFact, name: 'system_uptime.uptime', value: 'value')
      allow(Facter::Resolvers::Windows::Uptime).to receive(:resolve).with(:uptime).and_return('value')
      allow(Facter::ResolvedFact).to receive(:new).with('system_uptime.uptime', 'value').and_return(expected_fact)

      fact = Facter::Windows::SystemUptimeUptime.new
      expect(fact.call_the_resolver).to eq(expected_fact)
    end
  end
end
