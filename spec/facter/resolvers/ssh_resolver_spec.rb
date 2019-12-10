# frozen_string_literal: true

# ADD THE MOTHERFUCKING FIXTURE ALREADY

describe 'SSHResolver' do
  describe 'Check ssh folders and files' do
    context 'When the /etc/ssh folder exists' do
      let(:directory) { '/etc/ssh' }
      before do
        allow(File).to receive(:directory?).with(directory).and_return(true)
      end
      context 'when rsa file' do
        let(:file) { '/ssh_host_rsa_key.pub' }
        it 'exists' do
          allow(File).to receive(:file?).with(directory + file).and_return(true)
          allow(File).to receive(:read).with(directory + file).and_return(load_fixture('rsa'))
          result = Facter::Resolvers::SshResolver.resolve(:ssh)
          expect(result).to eql(file_content)
        end
        it 'doesnt exist' do
          allow(File).to receive(:file?).with(directory + file).and_return(false)
        end
      end
      context 'when ecdsa file' do
        let(:file) { '/ssh_host_ecdsa_key.pub' }
        let(:file_content) { '' }
        it 'exists' do
          allow(File).to receive(:file?).with(directory + file).and_return(true)
          allow(File).to receive(:join).with(directory + file)
          allow(File).to receive(:read).with(directory + file).and_return(load_fixture('ecdsa'))
          result = Facter::Resolvers::SshResolver.resolve(:ssh)
          expect(result).to eql(file_content)
        end
        it 'doesnt exist' do
          allow(File).to receive(:file?).with(directory + file).and_return(false)
        end
      end
      context 'when dsa file' do
        let(:file) { '/ssh_host_dsa_key.pub' }
        it 'exists' do
          allow(File).to receive(:file?).with(directory + file).and_return(true)
          allow(File).to receive(:read).with(directory + file).and_return(load_fixture('dsa'))
          result = Facter::Resolvers::SshResolver.resolve(:ssh)
          expect(result).to eql(file_content)
        end
        it 'doesnt exist' do
          allow(File).to receive(:file?).with(directory + file).and_return(false)
        end
      end
      context 'when ed25519 file' do
        let(:file) { '/ssh_host_ed25519_key.pub' }
        it 'exists' do
          allow(File).to receive(:file?).with(directory + file).and_return(true)
          allow(File).to receive(:read).with(directory + file).and_return(load_fixture('ed25519'))
          result = Facter::Resolvers::SshResolver.resolve(:ssh)
          expect(result).to eql(file_content)
        end
        it 'doesnt exist' do
          allow(File).to receive(:file?).with(directory + file).and_return(false)
        end
      end
    end
  end
end

