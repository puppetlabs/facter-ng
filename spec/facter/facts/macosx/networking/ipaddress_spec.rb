# frozen_string_literal: true

describe 'Macosx NetworkingIpaddress' do
  context '#call_the_resolver' do
    let(:value) { '10.0.0.1' }
    let(:expected_resolved_fact) { double(Facter::ResolvedFact, name: 'networking.ip', value: value) }
    subject(:fact) { Facter::Macosx::NetworkingIpaddress.new }

    before do
      allow(Facter::Resolvers::Macosx::Ipaddress).to receive(:resolve).with(:ip).and_return(value)
      allow(Facter::ResolvedFact).to receive(:new).with('networking.ip', value).and_return(expected_resolved_fact)
    end

    it 'calls Facter::Resolvers::Macosx::Ipaddress' do
      expect(Facter::Resolvers::Macosx::Ipaddress).to receive(:resolve).with(:ip)
      fact.call_the_resolver
    end

    it 'returns hostname fact' do
      expect(fact.call_the_resolver).to eq(expected_resolved_fact)
    end
  end
end
