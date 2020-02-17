# frozen_string_literal: true

zpool_command_response = "
This system is currently running ZFS pool version 34.

The following versions are supported:

VER  DESCRIPTION
---  --------------------------------------------------------
 1   Initial ZFS version
 2   Ditto blocks (replicated metadata)
 3   Hot spares and double parity RAID-Z
 4   zpool history
 5   Compression using the gzip algorithm
 6   bootfs pool property
 7   Separate intent log devices
 8   Delegated administration
 9   refquota and refreservation properties
 10  Cache devices
 11  Improved scrub performance
 12  Snapshot properties
 13  snapused property
 14  passthrough-x aclinherit
 15  user/group space accounting
 16  stmf property support
 17  Triple-parity RAID-Z
 18  Snapshot user holds
 19  Log device removal
 20  Compression using zle (zero-length encoding)
 21  Deduplication
 22  Received properties
 23  Slim ZIL
 24  System attributes
 25  Improved scrub stats
 26  Improved snapshot deletion performance
 27  Improved snapshot creation performance
 28  Multiple vdev replacements
 29  RAID-Z/mirror hybrid allocator
 30  Encryption
 31  Improved 'zfs list' performance
 32  One MB blocksize
 33  Improved share support
 34  Sharing with inheritance

For more information on a particular version, including supported releases,
see the ZFS Administration Guide.
"

describe 'ZPool' do
  before do
    status = double(Process::Status, to_s: st)
    expect(Open3).to receive(:capture2)
      .with('zpool upgrade -v')
      .ordered
      .and_return([output, status])
  end
  after do
    Facter::Resolvers::Solaris::ZPool.invalidate_cache
  end
  context 'Resolve ZPool facts' do
    let(:output) { zpool_command_response }
    let(:st) { 'exit 0' }
    it 'return zpool version fact' do
      result = Facter::Resolvers::Solaris::ZPool.resolve(:zpool_version)
      expect(result).to eq('34')
    end

    it 'return zpool feature numbers fact' do
      result = Facter::Resolvers::Solaris::ZPool.resolve(:zpool_featurenumbers)
      expect(result).to eq('1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23,' \
        ' 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34')
    end
  end
end
