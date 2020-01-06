# frozen_string_literal: true

describe 'Windows NetworkingHostname' do
  context '#call_the_resolver' do
    let(:value) { 'hostname' }
    let(:expected_resolved_fact) { double(Facter::ResolvedFact, name: 'networking.hostname', value: value) }
    let(:resolved_legacy_fact) { double(Facter::ResolvedFact, name: 'hostname', value: value, type: :legacy) }
    subject(:fact) { Facter::Windows::NetworkingHostname.new }

    before do
      expect(Facter::Resolvers::Hostname).to receive(:resolve).with(:hostname).and_return(value)
      expect(Facter::ResolvedFact).to receive(:new).with('networking.hostname', value)
                                                   .and_return(expected_resolved_fact)
      expect(Facter::ResolvedFact).to receive(:new).with('hostname', value, :legacy).and_return(resolved_legacy_fact)
    end

    it 'returns hostname fact' do
      expect(fact.call_the_resolver).to eq([expected_resolved_fact, resolved_legacy_fact])
    end
  end
end
