# frozen_string_literal: true

describe 'Windows NetworkingFqdn' do
  context '#call_the_resolver' do
    let(:expected_resolved_fact) { double(Facter::ResolvedFact, name: 'networking.fqdn', value: value) }
    let(:resolved_legacy_fact) { double(Facter::ResolvedFact, name: 'fqdn', value: value, type: :legacy) }
    subject(:fact) { Facter::Windows::NetworkingFqdn.new }

    before do
      allow(Facter::Resolvers::Networking).to receive(:resolve).with(:domain).and_return(domain_name)
      allow(Facter::Resolvers::Hostname).to receive(:resolve).with(:hostname).and_return(hostname)
      expect(Facter::ResolvedFact).to receive(:new).with('networking.fqdn', value).and_return(expected_resolved_fact)
    end

    context 'when domain and hostname could be resolved' do
      let(:domain_name) { 'domain' }
      let(:hostname) { 'hostname' }
      let(:value) { "#{hostname}.#{domain_name}" }

      before do
        expect(Facter::ResolvedFact).to receive(:new).with('fqdn', value, :legacy).and_return(resolved_legacy_fact)
      end

      it 'returns fqdn fact' do
        expect(fact.call_the_resolver).to eq([expected_resolved_fact, resolved_legacy_fact])
      end
    end

    context 'when it fails to retrieve hostname' do
      let(:domain_name) { 'domain' }
      let(:hostname) { nil }
      let(:value) { nil }

      it 'returns nil' do
        expect(fact.call_the_resolver).to eq(expected_resolved_fact)
      end
    end

    context 'when it fails to retrieve domain' do
      let(:domain_name) { nil }
      let(:hostname) { 'hostname' }
      let(:value) { hostname }

      before do
        expect(Facter::ResolvedFact).to receive(:new).with('fqdn', value, :legacy).and_return(resolved_legacy_fact)
      end

      it 'returns hostname as fqdn' do
        expect(fact.call_the_resolver).to eq([expected_resolved_fact, resolved_legacy_fact])
      end
    end

    context 'when hostname is empty' do
      let(:domain_name) { 'domain' }
      let(:hostname) { '' }
      let(:value) { nil }

      it 'returns nil' do
        expect(fact.call_the_resolver).to eq(expected_resolved_fact)
      end
    end
  end
end
