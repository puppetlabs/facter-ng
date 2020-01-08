# frozen_string_literal: true

module Facter
  module Resolvers
    class BaseResolver
      def self.invalidate_cache
        @fact_list = {}
      end

      def self.subscribe_to_manager
        Facter::CacheManager.subscribe(self)
      end

      def self.resolve(fact_name)
        @semaphore.synchronize do
          res(fact_name)
          subscribe_to_manager
        end
      rescue LoadError => e
        @log.error("resolving fact #{fact_name}, but #{e}")
        @fact_list[fact_name] = nil
      end

      def self.res(fact_name)
        raise NotImplementedError, "You must implement res(fact_name) method in #{self.name}"
      end
    end
  end
end
