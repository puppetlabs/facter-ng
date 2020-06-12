
# frozen_string_literal: true

module Facter
  module Resolvers
    class AioAgentVersion < BaseResolver
      @log = Facter::Log.new(self)
      @semaphore = Mutex.new
      @fact_list ||= {}

      class << self
        private

        def post_resolve(fact_name)
          @fact_list.fetch(fact_name) { read_version(fact_name) }
        end


        def read_version(fact_name)
          reg = ::Win32::Registry::HKEY_LOCAL_MACHINE.open('SOFTWARE\\Puppet Labs\\Puppet')
          build_fact_list(reg)
          reg.close

          @fact_list[fact_name]

        end

          def build_fact_list(reg)
            # rubocop:disable Performance/InefficientHashSearch
            @fact_list[:path] = reg['RememberedInstallDir64'] if reg.keys.include?('RememberedInstallDir64')
            # rubocop:enable Performance/InefficientHashSearch
          end
      end
    end
  end
end
