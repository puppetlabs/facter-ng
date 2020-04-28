# frozen_string_literal: true

require 'rbconfig'

describe OsDetector do
  let(:os_hierarchy) { instance_spy(Facter::OsHierarchy) }

  before do
    Singleton.__init__(OsDetector)

    allow(Facter::OsHierarchy).to receive(:new).and_return(os_hierarchy)
  end

  describe 'initialize' do
    context 'when os is macosx' do
      before do
        RbConfig::CONFIG['host_os'] = 'darwin'
        allow(os_hierarchy).to receive(:construct_hierarchy).with(:macosx).and_return(['macosx'])
        OsDetector.instance
      end

      it 'detects os as macosx' do
        expect(OsDetector.instance.identifier).to eq(:macosx)
      end

      it 'calls hierarchy construction with macosx identifier' do
        expect(os_hierarchy).to have_received(:construct_hierarchy).with(:macosx)
      end

      it 'construct hierarchy with darwin identifier' do
        expect(OsDetector.instance.hierarchy).to eq(['macosx'])
      end
    end

    context 'when os is windows' do
      before do
        RbConfig::CONFIG['host_os'] = 'mingw'
        allow(os_hierarchy).to receive(:construct_hierarchy).with(:windows).and_return(['windows'])
        OsDetector.instance
      end

      it 'detects os as windows' do
        expect(OsDetector.instance.identifier).to eq(:windows)
      end

      it 'calls hierarchy construction with windows identifier' do
        expect(os_hierarchy).to have_received(:construct_hierarchy).with(:windows)
      end

      it 'construct hierarchy with windows identifier' do
        expect(OsDetector.instance.hierarchy).to eq(['windows'])
      end
    end

    context 'when os is solaris' do
      before do
        RbConfig::CONFIG['host_os'] = 'solaris'
        allow(os_hierarchy).to receive(:construct_hierarchy).with(:solaris).and_return(['solaris'])
        OsDetector.instance
      end

      it 'detects os as solaris' do
        expect(OsDetector.instance.identifier).to eq(:solaris)
      end

      it 'calls hierarchy construction with solaris identifier' do
        expect(os_hierarchy).to have_received(:construct_hierarchy).with(:solaris)
      end

      it 'construct hierarchy with solaris identifier' do
        expect(OsDetector.instance.hierarchy).to eq(['solaris'])
      end
    end

    context 'when os is aix' do
      before do
        RbConfig::CONFIG['host_os'] = 'aix'
        allow(os_hierarchy).to receive(:construct_hierarchy).with(:aix).and_return(['aix'])
        OsDetector.instance
      end

      it 'detects os as aix' do
        expect(OsDetector.instance.identifier).to eq(:aix)
      end

      it 'calls hierarchy construction with aix identifier' do
        expect(os_hierarchy).to have_received(:construct_hierarchy).with(:aix)
      end

      it 'construct hierarchy with aix identifier' do
        expect(OsDetector.instance.hierarchy).to eq(['aix'])
      end
    end

    context 'when os cannot be detected' do
      before do
        RbConfig::CONFIG['host_os'] = 'my_custom_os'
      end

      it 'raises error if it could not detect os' do
        expect { OsDetector.instance.identifier }.to raise_error(RuntimeError, 'unknown os: "my_custom_os"')
      end
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

        allow(os_hierarchy).to receive(:construct_hierarchy).with(:redhat).and_return(%w[linux redhat])

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

      context 'when distribution is not known' do
        before do
          allow(Facter::Resolvers::RedHatRelease).to receive(:resolve).with(:identifier).and_return('my_linux_distro')
          allow(Facter::Resolvers::OsRelease).to receive(:resolve).with(:id_like).and_return(nil)

          allow(os_hierarchy).to receive(:construct_hierarchy).and_return([])
          allow(os_hierarchy).to receive(:construct_hierarchy).with(:linux).and_return(['linux'])
          Singleton.__init__(OsDetector)
          OsDetector.instance
        end

        it 'falls back to linux' do
          expect(OsDetector.instance.identifier).to eq(:my_linux_distro)
        end

        it 'constructs hierarchy with linux' do
          expect(OsDetector.instance.hierarchy).to eq(['linux'])
        end

        context 'when family is known' do
          before do
            allow(Facter::Resolvers::OsRelease).to receive(:resolve).with(:id_like).and_return(:ubuntu)
            allow(os_hierarchy).to receive(:construct_hierarchy).with(:ubuntu).and_return(%w[Linux Debian Ubuntu])
            Singleton.__init__(OsDetector)
            OsDetector.instance
          end

          it 'constructs hierarchy with linux' do
            expect(OsDetector.instance.hierarchy).to eq(%w[Linux Debian Ubuntu])
          end
        end
      end
    end
  end
end
