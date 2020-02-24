# frozen_string_literal: true

describe Facter::Resolvers::SELinux do
  after do
    Facter::Resolvers::SELinux.invalidate_cache
  end

  it 'returns false when selinux is not enabled' do
    allow(Open3).to receive(:capture2)
      .with('cat /proc/self/mounts')
      .and_return(load_fixture('proc_self_mounts').read)
    result = Facter::Resolvers::SELinux.resolve(:enabled)

    expect(result).to be_falsey
  end

  it 'returns true when selinux is enabled' do
    allow(Open3).to receive(:capture2)
      .with('cat /proc/self/mounts')
      .and_return(load_fixture('proc_self_mounts_selinux').read)
    result = Facter::Resolvers::SELinux.resolve(:enabled)

    expect(result).to be_truthy
  end
end
