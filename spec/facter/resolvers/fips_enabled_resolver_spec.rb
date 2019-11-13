# frozen_string_literal: true

describe 'FipsEnabledResolver' do

  before do
    allow(File).to receive(:read)
      .with('/proc/sys/crypto/fips_enabled')
      .and_return(fips_enabled)
  end
  context 'when fips is enabled' do
    let(:test_enabled) { '1 '}

    it 'returns fips enabled'
    result = Facter::Resolvers::Linux::FipsEnabled.resolve(:fips_enabled)

    expect(result).to eq(test_enabled)
  end
  context 'when fips is not enabled' do
    let(:fips_enabled) { '0' }

    it 'returns fips not enabled' do
    result = Facter::Resolvers::Linux::FipsEnabled.resolve(:fips_enabled)

    expect(result).to eq(fips_enabled)
    end
  end
end
