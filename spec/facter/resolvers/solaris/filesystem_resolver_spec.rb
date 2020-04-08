# frozen_string_literal: true

describe Facter::Resolvers::Solaris::Filesystem do
  subject(:resolver) { Facter::Resolvers::Solaris::Filesystem }

  let(:filesystems) { 'hsfs,nfs,pcfs,udfs,ufs' }

  after do
    Facter::Resolvers::Solaris::Filesystem.invalidate_cache
  end

  context 'when /usr/sbin/sysdef file is readable' do
    before do
      allow(Facter::Resolvers::Utils::FileHelper).to receive(:safe_readlines)
        .with('/usr/sbin/sysdef', nil).and_return(load_fixture('solaris_filesystems').readlines)
    end

    it 'returns filesystems' do
      result = resolver.resolve(:file_systems)

      expect(result).to eq(filesystems)
    end
  end

  context 'when /usr/sbin/sysdef file is not readable' do
    before do
      allow(Facter::Resolvers::Utils::FileHelper).to receive(:safe_readlines)
        .with('/usr/sbin/sysdef', nil).and_return(nil)
    end

    it 'returns filesystems' do
      result = resolver.resolve(:file_systems)

      expect(result).to be(nil)
    end
  end
end
