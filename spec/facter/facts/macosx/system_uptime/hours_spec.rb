# frozen_string_literal: true

describe 'Macosx SystemUptimeHours' do
  describe '#call_the_resolver' do
    let(:value) { '2' }

    it 'returns a fact' do
      expected_fact = double(Facter::ResolvedFact, name: 'system_uptime.hours', value: value)
      allow(Facter::Resolvers::Uptime).to receive(:resolve).with(:hours).and_return(value)
      allow(Facter::ResolvedFact).to receive(:new).with('system_uptime.hours', value).and_return(expected_fact)

      fact = Facter::Macosx::SystemUptimeHours.new
      expect(fact.call_the_resolver).to eq(expected_fact)
    end
  end
end
