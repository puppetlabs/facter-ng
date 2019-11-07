# frozen_string_literal: true

describe 'FipsEnabledResolver' do
  let(:fips_enabled) { 'false' }

  before do
    allow(File).to receive(:read)
      .with('/proc/sys/crypto/fips_enabled')
      .and_return(load_fixture('fips_enabled').read)
  end
  it 'returns fips_enabled' do
    result = Facter::Resolvers::Linux::FipsEnabled.resolve(:fips_enabled)

    expect(result).to eq(fips_enabled)
  end
end
