# frozen_string_literal: true

describe 'FactLoader' do
  describe '#initialize' do
    context 'load facts' do
      it 'loads one legacy fact' do
        allow_any_instance_of(Facter::ClassDiscoverer)
          .to receive(:discover_classes)
          .with(:Ubuntu)
          .and_return([:NetworkInterface])

        stub_const('Facter::Ubuntu::NetworkInterface::FACT_NAME', 'ipaddress_.*')

        fact_loader = Facter::FactLoader.new(:ubuntu)
        legacy_facts_hash = fact_loader.legacy_facts

        network_interface_class = Class.const_get('Facter::Ubuntu::NetworkInterface')

        expect(legacy_facts_hash['ipaddress_.*']).to eq(network_interface_class)
      end

      it 'loads one core fact' do
        allow_any_instance_of(Facter::ClassDiscoverer)
          .to receive(:discover_classes)
          .with(:Ubuntu)
          .and_return([:OsName])

        stub_const('Facter::Ubuntu::OsName::FACT_NAME', 'os.name')

        fact_loader = Facter::FactLoader.new(:ubuntu)
        core_facts_hash = fact_loader.core_facts

        os_name_class = Class.const_get('Facter::Ubuntu::OsName')
        expect(core_facts_hash['os.name']).to eq(os_name_class)
      end

      it 'loads one core fact and one legacy fact' do
        allow_any_instance_of(Facter::ClassDiscoverer)
          .to receive(:discover_classes)
          .with(:Ubuntu)
          .and_return(%i[NetworkInterface OsName])

        stub_const('Facter::Ubuntu::NetworkInterface::FACT_NAME', 'ipaddress_.*')
        stub_const('Facter::Ubuntu::OsName::FACT_NAME', 'os.name')

        fact_loader = Facter::FactLoader.new(:ubuntu)
        all_facts_hash = fact_loader.all_facts

        network_interface_class = Class.const_get('Facter::Ubuntu::NetworkInterface')
        os_name_class = Class.const_get('Facter::Ubuntu::OsName')

        expect(all_facts_hash['ipaddress_.*']).to eq(network_interface_class)
        expect(all_facts_hash['os.name']).to eq(os_name_class)
      end

      it 'loads no facts' do
        allow_any_instance_of(Facter::ClassDiscoverer)
          .to receive(:discover_classes)
          .with(:Ubuntu)
          .and_return([])
        fact_loader = Facter::FactLoader.new(:ubuntu)
        all_facts_hash = fact_loader.all_facts

        expect(all_facts_hash.size).to eq(0)
      end
    end
  end
end
