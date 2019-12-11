# frozen_string_literal: true

# ADD THE MOTHERFUCKING FIXTURE ALREADY

describe 'SshResolver' do
  describe '#folders' do
    describe 'When /etc/ssh folder exists' do
      before do
        allow(File).to receive(:directory?).with('/etc/ssh').and_return(true)
      end
      context 'rsa file exists' do
        let(:content) { load_fixture('rsa').read }
        it 'does' do
          allow(File).to receive(:file?).with('/etc/ssh/ssh_host_rsa_key.pub').and_return(true)
          allow(File).to receive(:read).with('/etc/ssh/ssh_host_rsa_key.pub').and_return(content)
          result = Facter::Resolvers::SshResolver.resolve(:ssh)
          expect(result).to eql(content)
        end
      end
      context 'rsa file doesnt exist' do
        it { allow(File).to receive(:file?).with('ssh_host_rsa_key.pub').and_return(false) }
      end
      context 'dsa file exists' do
        let(:content) { load_fixture('dsa').read }
        it 'does' do
          allow(File).to receive(:file?).with('/etc/ssh/ssh_host_dsa_key.pub').and_return(true)
          allow(File).to receive(:read).with('/etc/ssh/ssh_host_dsa_key.pub').and_return(content)
          result = Facter::Resolvers::SshResolver.resolve(:ssh)
          expect(result).to eql(content)
        end
      end
      context 'dsa file doesnt exist' do
        it { allow(File).to receive(:file?).with('ssh_host_dsa_key.pub').and_return(false) }
      end
      context 'ecdsa file exists' do
        let(:content) { load_fixture('ecdsa').read }
        it 'does' do
          allow(File).to receive(:file?).with('/etc/ssh/ssh_host_ecdsa_key.pub').and_return(true)
          allow(File).to receive(:read).with('/etc/ssh/ssh_host_ecdsa_key.pub').and_return(content)
          result = Facter::Resolvers::SshResolver.resolve(:ssh)
          expect(result).to eql(content)
        end
      end
      context 'ecdsa file doesnt exist' do
        it { allow(File).to receive(:file?).with('ssh_host_ecdsa_key.pub').and_return(false) }
      end
      context 'ed25519 file exists' do
        let(:content) { load_fixture('ed25519').read }
        it 'does' do
          allow(File).to receive(:file?).with('/etc/ssh/ssh_host_ed25519_key.pub').and_return(true)
          allow(File).to receive(:read).with('/etc/ssh/ssh_host_ed25519_key.pub').and_return(content)
          result = Facter::Resolvers::SshResolver.resolve(:ssh)
          expect(result).to eql(content)
        end
      end
      context 'ed22519 file doesnt exist' do
        it { allow(File).to receive(:file?).with('ssh_host_ed25519_key.pub').and_return(false) }
      end
    end
    #    describe ' NEXT POSSIBLE FILE ' do
    #      SAME SHIT GOES HERE
    #    end
  end
end
