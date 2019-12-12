# frozen_string_literal: true

describe 'SshResolver' do
  describe '#folders' do
    describe 'When /etc folder exists' do
      let(:paths) { %w[/etc/ssh /usr/local/etc/ssh /etc /usr/local/etc /etc/opt/ssh] }
      let(:file_names) { %w[ssh_host_rsa_key.pub ssh_host_dsa_key.pub ssh_host_ecdsa_key.pub ssh_host_ed25519_key.pub] }
      before do
        paths.each { |path| allow(File).to receive(:directory?).with(path).and_return(false) unless path == '/etc' }
        allow(File).to receive(:directory?).with('/etc').and_return(true)

        file_names.each do |file_name|
          unless file_name == 'ssh_host_rsa_key.pub'
            allow(File).to receive(:file?).with('/etc/' + file_name)
                                          .and_return(false)
          end
        end

        allow(File).to receive(:file?).with('/etc/ssh_host_ecdsa_key.pub').and_return(true)
        allow(File).to receive(:file?).with('/etc/ssh_host_rsa_key.pub').and_return(true)

        expect(File).to receive(:read).with('/etc/ssh_host_ecdsa_key.pub').and_return(content)
        expect(File).to receive(:read).with('/etc/ssh_host_rsa_key.pub').and_return(rsa_content)

        expect(Facter::FingerPrint)
          .to receive(:new)
          .with('SSHFP 3 1 fd92cf867fac0042d491eb1067e4f3cabf54039a',
                'SSHFP 3 2 a51271a67987d7bbd685fa6d7cdd2823a30373ab01420b094480523fabff2a05')
          .and_return(fingerprint)

        expect(Facter::FingerPrint)
          .to receive(:new)
          .with('SSHFP 1 1 90134f93fec6ab5e22bdd88fc4d7cd6e9dca4a07',
                'SSHFP 1 2 efaa26ff8169f5ffc372ebcad17aef886f4ccaa727169acdd0379b51c6c77e99')
          .and_return(rsa_fingerprint)

        expect(Facter::Ssh)
          .to receive(:new).with(fingerprint, 'ecdsa-sha2-nistp256', 'AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAA' \
          'IbmlzdHAyNTYAAABBBNG0AgjrPXt5/osLsmECV/qISOwaRmDW1yNSHZiAJvZ6p6ZUilg5vqtSskaUsT5XN8J2amVktN6wOHDwtWiEbpM=',
                                 'ecdsa')
                           .and_return(result)

        expect(Facter::Ssh)
          .to receive(:new).with(rsa_fingerprint, 'ssh-rsa', 'AAAAB3NzaC1yc2EAAAADAQABAAABgQDb4P6/Iw6/WoW1rM'\
          'bIdpq7qSd8ktGgta2CC3CGrx4AXxjbofyegH+B9wadIrmyNcHmLFAneAmeb+H/dewRMa5Hb7tMN8z+/X9MRzlMaZDGo+1CeXQkJ'\
          'z7SywJrMXb00VcfSmGKe+aHr4OSdN7cXsAR3BzjUSjXdCMkNcp7bw0gcQOmMtqpxFXzbLyFeQgaXtDGwVeByzE9//mhdNv5+pcg'\
          '3Jx0aC2ED9yrq78HpKYyvLx0t7SpE2i9y+meJxrk/SqlL2BJHAugRwXJkEexPr2hOoulc+PYcbEs8uGiliQEK6aqAtJYVgzcnrDaj'\
          'sElGkQnN9/A9uXY8N0VTLPbYBIz6v+XdWiSK+NA1uzb/GN1XnTvCP0XDTtpzBsMG/m9C02Hq6xQDDWsPp+xv2VfYlVCrlJVf/CHeKE'\
          'vy78WS+HMu3McvzKmP1Topow+utEqk4qfNxEs7FwwbdDcI02dsWJWJ+1FeCz+ZiscJI0LN0NKvM3xCLGt4hf6s9/JD9b6lO8=', 'rsa')
                           .and_return(rsa_result)
      end

      after do
        Facter::Resolvers::SshResolver.invalidate_cache
      end

      context 'ecdsa file exists' do
        let(:content) { load_fixture('ecdsa').read }
        let(:rsa_content) { load_fixture('rsa').read }

        let(:fingerprint) do
          double(Facter::FingerPrint,
                 sha1: 'SSHFP 3 1 fd92cf867fac0042d491eb1067e4f3cabf54039a',
                 sha256: 'SSHFP 3 2 a51271a67987d7bbd685fa6d7cdd2823a30373ab01420b094480523fabff2a05')
        end

        let(:rsa_fingerprint) do
          double(Facter::FingerPrint,
                 sha1: 'SSHFP 1 1 90134f93fec6ab5e22bdd88fc4d7cd6e9dca4a07',
                 sha256: 'SSHFP 1 2 efaa26ff8169f5ffc372ebcad17aef886f4ccaa727169acdd0379b51c6c77e99')
        end

        let(:result) do
          double(Facter::Ssh, fingerprint: fingerprint, type: 'ecdsa-sha2-nistp256',
                              key: 'AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBNG0AgjrPXt5/osLsmECV/qISOwa'\
                  'RmDW1yNSHZiAJvZ6p6ZUilg5vqtSskaUsT5XN8J2amVktN6wOHDwtWiEbpM=', name: 'ecdsa')
        end

        let(:rsa_result) do
          double(Facter::Ssh, fingerprint: rsa_fingerprint, type: 'ssh-rsa', key: 'AAAAB3NzaC1yc2EAAAADAQABAAABgQDb4P'\
          '6/Iw6/WoW1rMbIdpq7qSd8ktGgta2CC3CGrx4AXxjbofyegH+B9wadIrmyNcHmLFAneAmeb+H/dewRMa5Hb7tMN8z+/X9MRzlMaZDGo+1C'\
          'eXQkJz7SywJrMXb00VcfSmGKe+aHr4OSdN7cXsAR3BzjUSjXdCMkNcp7bw0gcQOmMtqpxFXzbLyFeQgaXtDGwVeByzE9//mhdNv5+pcg3J'\
          'x0aC2ED9yrq78HpKYyvLx0t7SpE2i9y+meJxrk/SqlL2BJHAugRwXJkEexPr2hOoulc+PYcbEs8uGiliQEK6aqAtJYVgzcnrDajsElGkQn'\
          'N9/A9uXY8N0VTLPbYBIz6v+XdWiSK+NA1uzb/GN1XnTvCP0XDTtpzBsMG/m9C02Hq6xQDDWsPp+xv2VfYlVCrlJVf/CHeKEvy78WS+HMu3'\
          'McvzKmP1Topow+utEqk4qfNxEs7FwwbdDcI02dsWJWJ+1FeCz+ZiscJI0LN0NKvM3xCLGt4hf6s9/JD9b6lO8=', name: 'rsa')
        end

        it 'returns fact' do
          expect(Facter::Resolvers::SshResolver.resolve(:ssh)).to eq([rsa_result, result])
        end
      end
      # context 'ecdsa file doesnt exist' do
      #   it { allow(File).to receive(:file?).with('ssh_host_ecdsa_key.pub').and_return(false) }
      # end
    end
  end
end
