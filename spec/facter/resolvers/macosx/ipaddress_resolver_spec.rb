# frozen_string_literal: true

describe 'IpaddressResolver' do
  describe '#resolve' do
    after do
      Facter::Resolvers::Macosx::Ipaddress.invalidate_cache
    end

    context 'when returns ip' do
      let(:route) do
        "route to: default
        destination: default
              mask: default
            gateway: 10.160.24.1
          interface: en0
              flags: <UP,GATEWAY,DONE,STATIC,PRCLONING>
        recvpipe  sendpipe  ssthresh  rtt,msec    rttvar  hopcount      mtu     expire
              0         0         0         0         0         0      1500         0"
      end
      let(:ip) { '10.0.0.1' }

      it 'detects ipadress' do
        allow(Open3).to receive(:capture2).with('route -n get default').and_return(route)
        allow(Open3).to receive(:capture2).with('ipconfig getifaddr en0').and_return(ip)
        expect(Facter::Resolvers::Macosx::Ipaddress.resolve(:ip)).to eql(ip)
      end
    end

    context 'when primary interface could not be retrieved' do
      let(:route) { 'invalid output' }

      it 'detects that ip is nil' do
        allow(Open3).to receive(:capture2).with('route -n get default').and_return(route)
        expect(Facter::Resolvers::Macosx::Ipaddress.resolve(:ip)).to eql(nil)
      end
    end
  end
end
