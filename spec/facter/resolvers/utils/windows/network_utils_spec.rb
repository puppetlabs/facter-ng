
# frozen_string_literal: true

describe 'NetworkUtils' do
  describe '#address_to_strig' do
    let(:addr) {double('SocketAddress')}
    let(:size) {double(FFI::MemoryPointer)}
    let(:buffer) {double(FFI::MemoryPointer)}
    let(:length) {32}

    before do
      allow(addr).to receive(:[]).with(:lpSockaddr).and_return(address)
      allow(FFI::MemoryPointer).to receive(:new).with(NetworkingFFI::INET6_ADDRSTRLEN + 1).and_return(size)
      allow(FFI::MemoryPointer).to receive(:new).with(:wchar, NetworkingFFI::INET6_ADDRSTRLEN + 1).and_return(buffer)
      allow(addr).to receive(:[]).with(:lpSockaddr).and_return(address)
      allow(addr).to receive(:[]).with(:iSockaddrLength).and_return(length)
      allow(NetworkingFFI).to receive(:WSAAddressToStringW)
                                  .with(address, length, FFI::Pointer::NULL, buffer, size).and_return(error)
      allow(buffer).to receive(:read_wide_string).and_return('10.123.0.2')
    end

    context 'when lpSockaddr is null' do
      let(:address) {FFI::Pointer::NULL}
      let(:error) {0}
      it 'returns nil' do
        expect(NetworkUtils.address_to_string(addr)).to eql(nil)
      end
    end

    context 'when error code is zero' do
      let(:address) {double(FFI::MemoryPointer)}
      let(:error) {0}
      it 'returns an address' do
        expect(NetworkUtils.address_to_string(addr)).to eql('10.123.0.2')
      end
    end

    context 'when error code is not zero' do
      let(:address) {double(FFI::MemoryPointer)}
      let(:error) {1}
      it 'returns nil and logs debug message' do
        allow_any_instance_of(Facter::Log).to receive(:debug).with('address to string translation failed!')
        expect(NetworkUtils.address_to_string(addr)).to eql(nil)
      end
    end
  end

  describe '#ignored_ipv4_address' do
    context 'when input is empty' do
      it 'returns true' do
        expect(NetworkUtils.ignored_ipv4_address('')).to eql(true)
      end
    end

    context 'when input starts with 127.' do
      it 'returns true' do
        expect(NetworkUtils.ignored_ipv4_address('127.255.0.2')).to eql(true)
      end
    end

    context 'when input is a valid ipv4 address' do
      it 'returns false' do
        expect(NetworkUtils.ignored_ipv4_address('169.255.0.2')).to eql(false)
      end
    end
  end

  describe '#ignored_ipv6_address' do
    context 'when input is empty' do
      it 'returns true' do
        expect(NetworkUtils.ignored_ipv6_address('')).to eql(true)
      end
    end

    context 'when input starts with fe80' do
      it 'returns true' do
        expect(NetworkUtils.ignored_ipv6_address('fe80::')).to eql(true)
      end
    end

    context 'when input equal with ::1' do
      it 'returns true' do
        expect(NetworkUtils.ignored_ipv6_address('::1')).to eql(true)
      end
    end

    context 'when input is a valid ipv6 address' do
      it 'returns false' do
        expect(NetworkUtils.ignored_ipv6_address('fe70::7d01:99a1:3900:531b')).to eql(false)
      end
    end
  end

  describe '#build_binding' do
    context 'when input is ipv4 address' do
      it 'returns ipv4 binding' do
        expect(NetworkUtils.build_binding('10.16.121.248')).to eql(false)
      end
    end
  end
end
