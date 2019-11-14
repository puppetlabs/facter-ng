# frozen_string_literal: true

describe 'FipsEnabledResolver' do
  describe '#resolve' do
    context 'when fips is not enabled' do

      it 'returns fips is not enabled' do
        allow(File).to receive(:read).with('/proc/sys/crypto/fips_enabled').and_return('0')
        result = Facter::Resolvers::Linux::FipsEnabled.resolve(:fips_enabled)

        expect(result).to eq(false)
      end
    end

    context 'when fips is enabled' do

      it 'returns fips is not enabled' do
        allow(File).to receive(:read).with('/proc/sys/crypto/fips_enabled').and_return('1')
        result = Facter::Resolvers::Linux::FipsEnabled.resolve(:fips_enabled)

        expect(result).to eq(true)
      end
    end
  end
end
