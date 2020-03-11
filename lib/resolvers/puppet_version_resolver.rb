# frozen_string_literal: true

module Facter
  module Resolvers
    class PuppetVersionResolver < BaseResolver
      # :puppetversion

      @semaphore = Mutex.new
      @fact_list ||= {}

      class << self
        private

        def post_resolve(fact_name)
          @fact_list.fetch(fact_name) { read_redhat_release(fact_name) }
        end

        def read_redhat_release(fact_name)
          require 'puppet/version'
          @fact_list[:puppetversion] = Puppet.version.to_s

          @fact_list[fact_name]
        end
      end
    end
  end
end
