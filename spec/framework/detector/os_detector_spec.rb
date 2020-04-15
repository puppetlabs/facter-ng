# frozen_string_literal: true

require 'rbconfig'

describe OsDetector do
  let(:os_hierarchy) { instance_spy(Facter::OsHierarchy) }

  before do
    Singleton.__init__(OsDetector)

    allow(Facter::OsHierarchy).to receive(:new).and_return(os_hierarchy)
  end

  describe 'initialize' do
    it 'detects os as macosx' do
      RbConfig::CONFIG['host_os'] = 'darwin'
      expect(OsDetector.instance.identifier).to eq(:macosx)
    end

    it 'detects os as windows' do
      RbConfig::CONFIG['host_os'] = 'mingw'
      expect(OsDetector.instance.identifier).to eq(:windows)
    end

    it 'detects os as solaris' do
      RbConfig::CONFIG['host_os'] = 'solaris'
      expect(OsDetector.instance.identifier).to eq(:solaris)
    end

    it 'detects os as aix' do
      RbConfig::CONFIG['host_os'] = 'aix'
      expect(OsDetector.instance.identifier).to eq(:aix)
    end

    it 'raise error if it could not detect os' do
      RbConfig::CONFIG['host_os'] = 'os'
      expect { OsDetector.instance.identifier }.to raise_error(RuntimeError, 'unknown os: "os"')
    end

    context 'when host_os is linux' do
      before do
        RbConfig::CONFIG['host_os'] = 'linux'

        allow(Facter::Resolvers::OsRelease).to receive(:resolve).with(:identifier)
        allow(Facter::Resolvers::RedHatRelease).to receive(:resolve).with(:identifier).and_return(:redhat)
        allow(Facter::Resolvers::SuseRelease).to receive(:resolve).with(:identifier)

        allow(Facter::Resolvers::OsRelease).to receive(:resolve).with(:version)
        allow(Facter::Resolvers::RedHatRelease).to receive(:resolve).with(:version)
        allow(Facter::Resolvers::SuseRelease).to receive(:resolve).with(:version)

        OsDetector.instance
      end

      it 'detects linux distro' do
        expect(OsDetector.instance.identifier).to be(:redhat)
      end

      it 'calls Facter::OsHierarchy with construct_hierarchy' do
        expect(os_hierarchy).to have_received(:construct_hierarchy).with(:redhat)
      end

      it 'calls Facter::Resolvers::OsRelease with identifier' do
        expect(Facter::Resolvers::OsRelease).to have_received(:resolve).with(:identifier)
      end

      it 'calls Facter::Resolvers::RedHatRelease with identifier' do
        expect(Facter::Resolvers::RedHatRelease).to have_received(:resolve).with(:identifier)
      end

      it 'calls Facter::Resolvers::OsRelease with version' do
        expect(Facter::Resolvers::OsRelease).to have_received(:resolve).with(:version)
      end

      it 'calls Facter::Resolvers::RedHatRelease with version' do
        expect(Facter::Resolvers::RedHatRelease).to have_received(:resolve).with(:version)
      end

      context 'when distribution is not detected' do
        before do
          allow(Facter::Resolvers::RedHatRelease).to receive(:resolve).with(:identifier).and_return(nil)
        end

        it 'falls back to linux' do
          Singleton.__init__(OsDetector)
          expect(OsDetector.instance.identifier).to be(:linux)
        end
      end
    end
  end
end
