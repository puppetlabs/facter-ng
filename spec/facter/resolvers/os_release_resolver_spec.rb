# frozen_string_literal: true

describe Facter::Resolvers::OsRelease do
  context 'when os is ubuntu' do
    before do
      allow(File).to receive(:readable?)
        .with('/etc/os-release')
        .and_return(true)

      allow(File).to receive(:read)
        .with('/etc/os-release')
        .and_return(load_fixture('os_release').read)
    end

    after do
      Facter::Resolvers::OsRelease.invalidate_cache
    end

    it 'returns os NAME' do
      result = Facter::Resolvers::OsRelease.resolve(:name)

      expect(result).to eq('Ubuntu')
    end

    it 'returns os PRETTY_NAME' do
      result = Facter::Resolvers::OsRelease.resolve(:pretty_name)

      expect(result).to eq('Ubuntu 18.04.1 LTS')
    end

    it 'returns os VERSION_ID' do
      result = Facter::Resolvers::OsRelease.resolve(:version_id)

      expect(result).to eq('18.04')
    end

    it 'returns os release' do
      result = Facter::Resolvers::OsRelease.resolve(:release)

      expect(result).to eq('18.04')
    end

    it 'returns os VERSION_CODENAME' do
      result = Facter::Resolvers::OsRelease.resolve(:version_codename)

      expect(result).to eq('bionic')
    end
  end

  context 'when os is Debian' do
    before do
      allow(File).to receive(:readable?).with('/etc/os-release').and_return(true)

      allow(File).to receive(:read)
        .with('/etc/os-release')
        .and_return(load_fixture('os_release_debian').read)

      allow(File).to receive(:readable?).with('/etc/debian_version').and_return(true)
      allow(File).to receive(:read).with('/etc/debian_version').and_return("10.0\n")
    end

    after do
      Facter::Resolvers::OsRelease.invalidate_cache
    end

    it 'returns os release' do
      result = Facter::Resolvers::OsRelease.resolve(:release)

      expect(result).to eq('10.0')
    end

    it 'returns os NAME' do
      result = Facter::Resolvers::OsRelease.resolve(:name)

      expect(result).to eq('Debian')
    end

    it 'returns os PRETTY_NAME' do
      result = Facter::Resolvers::OsRelease.resolve(:pretty_name)

      expect(result).to eq('Debian GNU/Linux 10 (buster)')
    end

    it 'returns os VERSION_ID' do
      result = Facter::Resolvers::OsRelease.resolve(:version_id)

      expect(result).to eq('10')
    end

    it 'returns os VERSION_CODENAME' do
      result = Facter::Resolvers::OsRelease.resolve(:version_codename)

      expect(result).to eq('buster')
    end
  end
end
