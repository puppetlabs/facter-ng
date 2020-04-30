# frozen_string_literal: true

describe Facter::Resolvers::Freebsd::FreebsdVersion do
  before do
    allow(Open3).to receive(:capture2)
      .with('/bin/freebsd-version -kru')
      .and_return('13.0-CURRENT
        12.1-RELEASE-p3
        12.0-STABLE')
  end

  it 'returns installed kernel' do
    result = Facter::Resolvers::Freebsd::FreebsdVersion.resolve(:installed_kernel)

    expect(result).to eq('13.0-CURRENT')
  end

  it 'returns running kernel' do
    result = Facter::Resolvers::Freebsd::FreebsdVersion.resolve(:running_kernel)

    expect(result).to eq('12.1-RELEASE-p3')
  end

  it 'returns installed userland' do
    result = Facter::Resolvers::Freebsd::FreebsdVersion.resolve(:installed_userland)

    expect(result).to eq('12.0-STABLE')
  end
end
