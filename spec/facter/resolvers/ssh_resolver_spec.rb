# frozen_string_literal: true

describe 'SSHResolver' do
  before do
    @file_names = %w[ssh_host_rsa_key.pub ssh_host_dsa_key.pub ssh_host_ecdsa_key.pub ssh_host_ed25519_key.pub]
    @file_paths = %w[/etc/ssh /usr/local/etc/ssh /etc /usr/local/etc /etc/opt/ssh]
    @file_paths.each do |directory_path|
      @file_names.each do |file_name|
        file_address = directory_path + file_name
        allow(File).to receive(:directory?).with(directory_path).and_return(true)
        allow(File).to receive(:file?).with(file_name).and_return(true)
        allow(File).to receive(:read).with(file_address).and_return(:file_address)
      end
    end
  end
  context '#resolve ssh facts' do
    it 'detects ruby sitedir' do
      result = Facter::Resolvers::SshResolver.resolve(:ssh)
      expect(result).to eql(file_address)
    end
  end
end
