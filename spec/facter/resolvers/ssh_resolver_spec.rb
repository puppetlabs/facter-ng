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
        allow(Facter::FingerPrint).to receive(:new).and_return(fingerprint)
        allow(Facter::Ssh).to receive(:new).and_return(result)
      end
      after do
        Facter::Resolvers::SshResolver.invalidate_cache
      end

      context 'ecdsa file exists' do
        let(:content) { load_fixture('ecdsa').read }
        let(:fingerprint) do
          Facter::FingerPrint.new('SSHFP 3 1 fd92cf867fac0042d491eb1067e4f3cabf54039a',
                                  'SSHFP 3 2 a51271a67987d7bbd685fa6d7cdd2823a30373ab01420b094480523fabff2a05')
        end
        let(:result) do
          Facter::Ssh.new(fingerprint, 'ecdsa-sha2-nistp256', 'AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAA' \
'IbmlzdHAyNTYAAABBBNG0AgjrPXt5/osLsmECV/qISOwaRmDW1yNSHZiAJvZ6p6ZUilg5vqtSskaUsT5XN8J2amVktN6wOHDwtWiEbpM=',
                          'ecdsa')
        end
        it 'returns fact' do
          expect(Facter::Resolvers::SshResolver.resolve(:ssh)).to eql([result])
        end
      end
      # context 'ecdsa file doesnt exist' do
      #   it { allow(File).to receive(:file?).with('ssh_host_ecdsa_key.pub').and_return(false) }
      # end
    end
  end
end
