# frozen_string_literal: true

describe Facter::Resolvers::AioAgentVersion do
  describe '#resolve' do
    before do
      allow(Facter::Util::FileHelper)
        .to receive(:safe_read)
        .with('/opt/puppetlabs/puppet/VERSION', nil)
        .and_return('7.0.1')
    end

    it 'calls FileHelper.safe_read' do
      Facter::Resolvers::AioAgentVersion.resolve(:aio_agent_version)

      expect(Facter::Util::FileHelper).to have_received(:safe_read).with('/opt/puppetlabs/puppet/VERSION', nil)
    end

    it 'detects puppet version' do
      expect(Facter::Resolvers::AioAgentVersion.resolve(:aio_agent_version)).to eql('7.0.1')
    end
  end
end
