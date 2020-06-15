# frozen_string_literal: true

describe Facter::Resolvers::AioAgentVersion do
  describe '#resolve' do
    it 'detects puppet version' do
      allow(Facter::Util::FileHelper)
        .to receive(:safe_read)
        .with('/opt/puppetlabs/puppet/VERSION', nil)
        .and_return('7.0.1')

      expect(Facter::Resolvers::AioAgentVersion.resolve(:aio_agent_version)).to eql('7.0.1')
    end
  end
end
