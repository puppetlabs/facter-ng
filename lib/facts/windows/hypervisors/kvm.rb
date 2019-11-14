# frozen_string_literal: true

module Facter
  module Windows
    class HypervisorsKvm
      FACT_NAME = 'hypervisors.kvm'

      def call_the_resolver
        fact_value = google_or_openstack || {} if kvm?

        ResolvedFact.new(FACT_NAME, fact_value)
      end

      private

      def kvm?
        product_name = Resolvers::DMIComputerSystem.resolve(:name)

        Resolvers::Virtualization.resolve(:virtual) == 'kvm' &&
          product_name != 'VirtualBox' && !product_name.match(/^Parallels/)
      end

      def google_or_openstack
        return { google: true } if Resolvers::DMIBios.resolve(:manufacturer) == 'Google'

        { openstack: true } if Resolvers::DMIComputerSystem.resolve(:name).match(/^OpenStack/)
      end
    end
  end
end
