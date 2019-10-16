# frozen_string_literal: true

describe 'Fedora AioAgentVersion' do
  context '#call_the_resolver' do
    it 'returns a fact' do
      value = '6.0.9'

      expected_fact = double(Facter::ResolvedFact, name: 'aio_agent_version', value: value)
      allow(Facter::Resolvers::Agent).to receive(:resolve).with(:aio_agent_version).and_return(value)
      allow(Facter::ResolvedFact).to receive(:new).with('aio_agent_version', value).and_return(expected_fact)

      fact = Facter::Fedora::AioAgentVersion.new
      expect(fact.call_the_resolver).to eq(expected_fact)
    end
  end
end
