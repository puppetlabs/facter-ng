
# frozen_string_literal: true

module Facter
  module Windows
    class HypervisorsKvm
      FACT_NAME = 'hypervisors.kvm'

      def call_the_resolver
        fact_name = if kvm?

        ResolvedFact.new(FACT_NAME, fact_value)
      end

      private

      def kvm?
        product_name = Resolvers::DMIComputerSystem.resolve(:name)

        Resolvers::CpuidSource.resolve(:vendor) == 'KVMKVMKVM' &&
            product_name != 'VirtualBox' && !product_name.match?(/^Parallels/)
      end
    end
  end
end


#  // VirtualBox and Parallels will also report KVM in CPUID, though, so make sure they're not here.
#         if (cpuid_source.vendor() == "KVMKVMKVM"
#             && smbios_source.product_name() != "VirtualBox"
#             && !re_search(smbios_source.product_name(), parallels_pattern)) {
#             res.validate();
#
#             if (smbios_source.bios_vendor() == "Google") {
#                 res.set("google", true);
#             }
#
#             if (re_search(smbios_source.product_name(), openstack_pattern)) {
#                 res.set("openstack", true);
#             }
#         }
#
#
#
#   bios_vendor = bios.manufacturer
#   product_name = computersystemproduct.name
#
#
# static const boost::regex openstack_pattern {"^OpenStack"};
# static const boost::regex parallels_pattern {"^Parallels"};