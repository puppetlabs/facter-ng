# frozen_string_literal: true

module Facts
  module Linux
    class Virtual
      FACT_NAME = 'virtual'

      def call_the_resolver
        fact_value = check_docker_lxc || check_gce || retrieve_from_virt_what || check_vmware
        fact_value ||= check_open_vz || check_vserver || check_xen

        Facter::ResolvedFact.new(FACT_NAME, fact_value)
      end

      def check_gce
        bios_vendor = Facter::Resolvers::Linux::DmiBios.resolve(:bios_vendor)
        'gce' if bios_vendor&.include?('Google')
      end

      def check_docker_lxc
        Facter::Resolvers::DockerLxc.resolve(:vm)
      end

      def check_vmware
        Facter::Resolvers::Vmware.resolve(:vm)
      end

      def retrieve_from_virt_what
        Facter::Resolvers::VirtWhat.resolve(:vm)
      end

      def check_open_vz
        Facter::Resolvers::OpenVz.resolve(:vm)
      end

      def check_vserver
        Facter::Resolvers::VirtWhat.resolve(:vserver)
      end

      def check_xen
        Facter::Resolvers::Xen.resolve(:vm)
      end
    end
  end
end
