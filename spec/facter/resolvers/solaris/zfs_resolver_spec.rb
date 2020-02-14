# frozen_string_literal: true

zfs_command_response = "
The following filesystem versions are supported:

VER  DESCRIPTION
---  --------------------------------------------------------
 1   Initial ZFS filesystem version
 2   Enhanced directory entries
 3   Case insensitive and SMB credentials support
 4   userquota, groupquota properties
 5   System attributes
 6   Multilevel file system support

For more information on a particular version, including supported releases,
see the ZFS Administration Guide.

"

describe 'SolarisZFS' do
  before do
    status = double(Process::Status, to_s: st)
    expect(Open3).to receive(:capture2)
      .with('zfs upgrade -v')
      .ordered
      .and_return([output, status])
  end
  after do
    Facter::Resolvers::Solaris::ZFS.invalidate_cache
  end
  context 'Resolve zfs facts' do
    let(:output) { zfs_command_response }
    let(:st) { 'exit 0' }
    it 'returns zfs facts' do
      result = Facter::Resolvers::Solaris::ZFS.resolve(:zfs_version)
      expect(result).to eq('6')

      result = Facter::Resolvers::Solaris::ZFS.resolve(:zfs_featurenumbers)
      expect(result).to eq('1, 2, 3, 4, 5, 6')
    end
  end
end
