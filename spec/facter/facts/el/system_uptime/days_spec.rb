# frozen_string_literal: true

describe Facts::El::SystemUptime::Days do
  describe '#call_the_resolver' do
    it 'returns a fact' do
      value = '0'

      expected_fact = double(Facter::ResolvedFact, name: 'system_uptime.days', value: value)
      allow(Facter::Resolvers::Uptime).to receive(:resolve).with(:days).and_return(value)
      allow(Facter::ResolvedFact).to receive(:new).with('system_uptime.days', value).and_return(expected_fact)

      fact = Facts::El::SystemUptime::Days.new
      expect(fact.call_the_resolver).to eq(expected_fact)
    end
  end
end
