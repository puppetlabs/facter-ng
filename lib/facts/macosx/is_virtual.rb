# frozen_string_literal: true

module Facter
  module Macosx
    class IsVirtual
      FACT_NAME = 'is_virtual'

      def call_the_resolver
        ResolvedFact.new(FACT_NAME, virtual?.to_s)
      end

      def virtual?
        # Set of hypervisor values we consider to not be virtual
        hypervisors = %w[physical
                         xen0
                         vmware_server
                         vmware_workstation
                         openvzhn
                         vserver_host]

        hypervisor = hypervisor_name
        hypervisor = 'physical' if hypervisor.nil?
        hypervisors.count(hypervisor).zero?
      end

      def hypervisor_name
        # model_identifier = Facter::Resolvers::SystemProfiler.resolve(:model_identifier)
        model_identifier = `system_profiler SPHardwareDataType | awk '/Model Identifier/ {print $3}'`
        return 'vmware' if model_identifier.start_with?('VMware')

        # boot_rom_version = Facter::Resolvers::SystemProfiler.resolve(:boot_rom_version)
        boot_rom_version = `system_profiler SPHardwareDataType | awk '/Boot ROM Version/ {print $4}'`
        return 'virtualbox' if boot_rom_version.start_with?('VirtualBox')

        # subsystem_vendor_id = Facter::Resolvers::SystemProfiler.resolve(:subsystem_vendor_id)
        subsystem_vendor_id = `system_profiler SPEthernetDataType | awk '/Subsystem Vendor ID/ {print $4}'`
        return 'parallels' if subsystem_vendor_id.start_with?('0x1ab8')
      end
    end
  end
end
