# frozen_string_literal: true

module Facts
  module Windows
    module Hypervisors
      class Kvm
        FACT_NAME = 'hypervisors.kvm'

        def call_the_resolver
          fact_value = discover_provider || {} if kvm?

          Facter::ResolvedFact.new(FACT_NAME, fact_value)
        end

        private

        def kvm?
          product_name = Facter::Resolvers::DMIComputerSystem.resolve(:name)

          (Facter::Resolvers::Virtualization.resolve(:virtual) == 'kvm' || Facter::Resolvers::NetKVM.resolve(:kvm)) &&
            product_name != 'VirtualBox' && !product_name.start_with?('Parallels')
        end

        def discover_provider
          manufacturer = Facter::Resolvers::DMIBios.resolve(:manufacturer)

          return { google: true } if manufacturer == 'Google'

          return { openstack: true } if Facter::Resolvers::DMIComputerSystem.resolve(:name).start_with?('OpenStack')

          return { amazon: true } if manufacturer.start_with?('Amazon')
        end
      end
    end
  end
end
