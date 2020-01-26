# frozen_string_literal: true

describe 'Ip' do
  context '#resolve' do
    before do
      allow(Open3).to receive(:capture2)
        .with('ip -o address')
        .and_return(load_fixture('ip_linux'))
      allow(Open3).to receive(:capture2)
        .with('ip route get 1')
        .and_return(load_fixture('ip_route__get_1_linux'))
      allow(Open3).to receive(:capture2)
        .with('ip address')
        .and_return(load_fixture('ip_address_linux'))
    end

    it 'develops' do
      Facter::Resolvers::Networking.resolve(:ip)
    end
  end
end
