# frozen_string_literal: true

describe 'SshResolver' do
  describe '#folders' do
    describe 'When /etc folder exists' do
      let(:paths) { %w[/etc/ssh /usr/local/etc/ssh /etc /usr/local/etc /etc/opt/ssh] }
      let(:file_names) { %w[ssh_host_rsa_key.pub ssh_host_dsa_key.pub ssh_host_ecdsa_key.pub ssh_host_ed25519_key.pub] }
      before do
        paths.each { |path| allow(File).to receive(:directory?).with(path).and_return(false) unless path == '/etc' }
        allow(File).to receive(:directory?).with('/etc').and_return(true)
        file_names.each do |file|
          if file == 'ssh_host_ecdsa_key.pub'
            allow(File).to receive(:file?).with('/etc/' + file).and_return(true)
          else
            allow(File).to receive(:file?).with('/etc/' + file).and_return(false)
          end
        end
        allow(File).to receive(:read).with('/etc/ssh_host_ecdsa_key.pub').and_return(content)
      end
      after do
        Facter::Resolvers::SshResolver.invalidate_cache()
      end

      context 'ecdsa file exists' do
        let(:content) { load_fixture('ecdsa').read }
        it 'returns fact' do
          expect(Facter::Resolvers::SshResolver.resolve(:ssh)).to eql(content)
        end
      end
      # context 'ecdsa file doesnt exist' do
      #   it { allow(File).to receive(:file?).with('ssh_host_ecdsa_key.pub').and_return(false) }
      # end

    end
  end
end
