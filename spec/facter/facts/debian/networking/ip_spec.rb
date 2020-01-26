# frozen_string_literal: true

describe 'Debian NetworkingIp' do
  context '#call_the_resolver' do
    let(:value) { '10.16.122.163' }
    subject(:fact) { Facter::Debian::NetworkingIp.new }

    before do
      allow(Facter::Resolvers::Linux::Networking).to receive(:resolve).with(:ip).and_return(value)
    end

    it 'calls Facter::Resolvers::Hostname' do
      expect(Facter::Resolvers::Linux::Networking).to receive(:resolve).with(:ip).and_return(value)
      fact.call_the_resolver
    end

    it 'returns hostname fact' do
      be_an_instance_of(Array)
        .and contain_exactly(an_object_having_attributes(name: 'ip', value: value),
                             an_object_having_attributes(name: 'ipaddress', value: value, type: :legacy))
    end
  end
end
