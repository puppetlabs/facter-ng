# frozen_string_literal: true

# ADD THE MOTHERFUCKING FIXTURE ALREADY

describe 'SSHResolver' do
  describe 'Check ssh folders and files' do
    context 'When the /etc/ssh folder exists' do
      let(:directory) { '/etc/ssh' }
      before do
        allow(File).to receive(:directory?).with(directory).and_return(true)
        allow(File).to receive(:file?).with(directory + file).and_return(true)
      end
      context 'when rsa file exists' do
        it 'detects rsa' do
          let(:file) { '/ssh_host_rsa_key.pub' }
          allow(File).to receive(:read).with(directory + file).and_return(load_fixture('rsa'))
          result = Facter::Resolvers::SshResolver.resolve(:ssh)
          expect(result).to eql(file_content)
        end
      end
      context 'when ecdsa file exists' do
        it 'detects ecdsa' do
          let(:file) { '/ssh_host_ecdsa_key.pub' }
          let(:file_content) { '' }
          allow(File).to receive(:read).with(directory + file).and_return(load_fixture('ecdsa'))
          result = Facter::Resolvers::SshResolver.resolve(:ssh)
          expect(result).to eql(file_content)
        end
      end
      context 'when dsa file exists' do
        it 'detects dsa' do
          let(:file) { '/ssh_host_dsa_key.pub' }
          allow(File).to receive(:read).with(directory + file).and_return(load_fixture('dsa'))
          result = Facter::Resolvers::SshResolver.resolve(:ssh)
          expect(result).to eql(file_content)
        end
      end
      context 'when ed25519 file exists' do
        it 'detects ed25519' do
          let(:file) { '/ssh_host_ed25519_key.pub' }
          allow(File).to receive(:read).with(directory + file).and_return(load_fixture('ed25519'))
          result = Facter::Resolvers::SshResolver.resolve(:ssh)
          expect(result).to eql(file_content)
        end
      end
    end
    describe 'Folder /usr/local/etc/ssh' do
      let(:directory) { '/usr/local/etc/ssh' }
      before do
        allow(File).to receive(:directory?).with(directory).and_return(true)
        allow(File).to receive(:file?).with(directory + file).and_return(true)
      end
      it 'detects rsa' do
        let(:file) { '/ssh_host_rsa_key.pub' }
        allow(File).to receive(:read).with(directory + file).and_return(load_fixture('rsa'))
        result = Facter::Resolvers::SshResolver.resolve(:ssh)
        expect(result).to eql(file_content)
      end
      it 'detects ecdsa' do
        let(:file) { '/ssh_host_ecdsa_key.pub' }
        allow(File).to receive(:read).with(directory + file).and_return(load_fixture('ecdsa'))
        result = Facter::Resolvers::SshResolver.resolve(:ssh)
        expect(result).to eql(file_content)
      end
      it 'detects dsa' do
        let(:file) { '/ssh_host_dsa_key.pub' }
        allow(File).to receive(:read).with(directory + file).and_return(load_fixture('dsa'))
        result = Facter::Resolvers::SshResolver.resolve(:ssh)
        expect(result).to eql(file_content)
      end
      it 'detects ed25519' do
        let(:file) { '/ssh_host_ed25519_key.pub' }
        allow(File).to receive(:read).with(directory + file).and_return(load_fixture('ed25519'))
        result = Facter::Resolvers::SshResolver.resolve(:ssh)
        expect(result).to eql(file_content)
      end
    end
    describe 'Folder /etc' do
      let(:directory) { '/etc' }
      before do
        allow(File).to receive(:directory?).with(directory).and_return(true)
        allow(File).to receive(:file?).with(directory + file).and_return(true)
      end
      it 'detects rsa' do
        let(:file) { '/ssh_host_rsa_key.pub' }
        allow(File).to receive(:read).with(directory + file).and_return(load_fixture('rsa'))
        result = Facter::Resolvers::SshResolver.resolve(:ssh)
        expect(result).to eql(file_content)
      end
      it 'detects ecdsa' do
        let(:file) { '/ssh_host_ecdsa_key.pub' }
        allow(File).to receive(:read).with(directory + file).and_return(load_fixture('ecdsa'))
        result = Facter::Resolvers::SshResolver.resolve(:ssh)
        expect(result).to eql(file_content)
      end
      it 'detects dsa' do
        let(:file) { '/ssh_host_dsa_key.pub' }
        allow(File).to receive(:read).with(directory + file).and_return(load_fixture('dsa'))
        result = Facter::Resolvers::SshResolver.resolve(:ssh)
        expect(result).to eql(file_content)
      end
      it 'detects ed25519' do
        let(:file) { '/ssh_host_ed25519_key.pub' }
        allow(File).to receive(:read).with(directory + file).and_return(load_fixture('ed25519'))
        result = Facter::Resolvers::SshResolver.resolve(:ssh)
        expect(result).to eql(file_content)
      end
    end
    describe 'Folder /usr/local/etc' do
      let(:directory) { '/usr/local/etc' }
      before do
        allow(File).to receive(:directory?).with(directory).and_return(true)
        allow(File).to receive(:file?).with(directory + file).and_return(true)
      end
      it 'detects rsa' do
        let(:file) { '/ssh_host_rsa_key.pub' }
        allow(File).to receive(:read).with(directory + file).and_return(load_fixture('rsa'))
        result = Facter::Resolvers::SshResolver.resolve(:ssh)
        expect(result).to eql(file_content)
      end
      it 'detects ecdsa' do
        let(:file) { '/ssh_host_ecdsa_key.pub' }
        allow(File).to receive(:read).with(directory + file).and_return(load_fixture('ecdsa'))
        result = Facter::Resolvers::SshResolver.resolve(:ssh)
        expect(result).to eql(file_content)
      end
      it 'detects dsa' do
        let(:file) { '/ssh_host_dsa_key.pub' }
        allow(File).to receive(:read).with(directory + file).and_return(load_fixture('dsa'))
        result = Facter::Resolvers::SshResolver.resolve(:ssh)
        expect(result).to eql(file_content)
      end
      it 'detects ed25519' do
        let(:file) { '/ssh_host_ed25519_key.pub' }
        allow(File).to receive(:read).with(directory + file).and_return(load_fixture('ed25519'))
        result = Facter::Resolvers::SshResolver.resolve(:ssh)
        expect(result).to eql(file_content)
      end
    end
    describe 'Folder /etc/opt/ssh' do
      let(:directory) { '/etc/opt/ssh' }
      before do
        allow(File).to receive(:directory?).with(directory).and_return(true)
        allow(File).to receive(:file?).with(directory + file).and_return(true)
      end
      it 'detects rsa' do
        let(:file) { '/ssh_host_rsa_key.pub' }
        allow(File).to receive(:read).with(directory + file).and_return(load_fixture('rsa'))
        result = Facter::Resolvers::SshResolver.resolve(:ssh)
        expect(result).to eql(file_content)
      end
      it 'detects ecdsa' do
        let(:file) { '/ssh_host_ecdsa_key.pub' }
        allow(File).to receive(:read).with(directory + file).and_return(load_fixture('ecdsa'))
        result = Facter::Resolvers::SshResolver.resolve(:ssh)
        expect(result).to eql(file_content)
      end
      it 'detects dsa' do
        let(:file) { '/ssh_host_dsa_key.pub' }
        allow(File).to receive(:read).with(directory + file).and_return(load_fixture('dsa'))
        result = Facter::Resolvers::SshResolver.resolve(:ssh)
        expect(result).to eql(file_content)
      end
      it 'detects ed25519' do
        let(:file) { '/ssh_host_ed25519_key.pub' }
        allow(File).to receive(:read).with(directory + file).and_return(load_fixture('ed25519'))
        result = Facter::Resolvers::SshResolver.resolve(:ssh)
        expect(result).to eql(file_content)
      end
    end
  end
end

