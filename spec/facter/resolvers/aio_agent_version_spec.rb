# frozen_string_literal: true

describe Facter::Resolvers::Agent do
  describe '#resolve' do
    it 'detects puppet version' do
      allow(File).to receive(:read).with("#{ROOT_DIR}/agent/AIO_VERSION").and_return('7.0.1')
      expect(Facter::Resolvers::Agent.resolve(:aio_agent_version)).to eql('7.0.1')
    end
  end
end
