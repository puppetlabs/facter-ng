describe Facter::Resolvers::BaseResolver do
  class TestResolver < Facter::Resolvers::BaseResolver
    @semaphore = Mutex.new
    @fact_list ||= {}
    class << self
      attr_accessor :fact_list

      def logger
        @log
      end

      def reset_logger
        @log = nil
      end
    end
  end

  subject(:resolver) { TestResolver }

  let(:fact) { 'fact' }

  describe '#log' do
    before do
      resolver.reset_logger
      allow(Facter::Log).to receive(:new).with(resolver).and_return('logger')
    end

    it 'initializes the log' do
      resolver.log

      expect(Facter::Log).to have_received(:new).with(resolver)
    end

    it 'initializes the log only once' do
      resolver.log
      resolver.log

      expect(Facter::Log).to have_received(:new).with(resolver).once
    end
  end

  describe '#invalidate_cache' do
    it 'clears the facts_list' do
      resolver.fact_list = { fact => 'fact value' }

      resolver.invalidate_cache

      expect(resolver.fact_list).to be_empty
    end
  end

  describe '#subscribe_to_manager' do
    it 'calls the CacheManager subscribe method' do
      allow(Facter::CacheManager).to receive(:subscribe).with(resolver)

      resolver.subscribe_to_manager

      expect(Facter::CacheManager).to have_received(:subscribe).with(resolver)
    end
  end

  describe '#resolve' do
    context 'fact is resolved successfully' do
      before do
        allow(Facter::CacheManager).to receive(:subscribe).with(resolver)
        allow(resolver).to receive(:post_resolve)
      end

      it 'calls the CacheManager subscribe method' do
        resolver.resolve(fact)

        expect(Facter::CacheManager).to have_received(:subscribe).with(resolver)
      end

      it 'calls the post_resolve method' do
        resolver.resolve(fact)

        expect(resolver).to have_received(:post_resolve).with(fact)
      end
    end

    context 'exception Load Error is raised when resolve is called' do
      before do
        resolver.reset_logger
        allow(resolver).to receive(:post_resolve).and_raise(LoadError)
        allow(Facter::Log).to receive(:new).with(resolver).and_return(double(Facter::Log, :debug => nil))
      end

      it 'logs the Load Error exception' do
        resolver.resolve(fact)

        expect(resolver.logger).to have_received(:debug).with("resolving fact #{fact}, but LoadError")
      end

      it 'sets the fact to nil' do
        resolver.resolve(fact)

        expect(resolver.fact_list).to match({ fact => nil })
      end
    end
  end

  describe '#post_resolve' do
    it 'raises NotImplementedError error' do
      expect { resolver.post_resolve(fact) }.to \
        raise_error(NotImplementedError,
                    "You must implement post_resolve(fact_name) method in #{resolver}")
    end
  end
end
