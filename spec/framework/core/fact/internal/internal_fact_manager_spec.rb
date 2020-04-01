# frozen_string_literal: true

describe Facter::InternalFactManager do
  describe '#resolve_facts' do
    it 'resolved one core fact' do
      os_name_class_spy = class_spy(Facts::Debian::Os::Name)
      os_name_instance_spy = instance_spy(Facts::Debian::Os::Name)

      resolved_fact = mock_resolved_fact('os', 'Ubuntu', nil, [])

      allow(os_name_class_spy).to receive(:new).and_return(os_name_instance_spy)
      allow(os_name_instance_spy).to receive(:call_the_resolver).and_return(resolved_fact)

      searched_fact = instance_spy(Facter::SearchedFact, name: 'os', fact_class: os_name_class_spy, filter_tokens: [],
                                                         user_query: '', type: :core)

      core_fact_manager = Facter::InternalFactManager.new
      resolved_facts = core_fact_manager.resolve_facts([searched_fact])

      expect(resolved_facts).to eq([resolved_fact])
    end

    it 'resolved one legacy fact' do
      networking_interface_class_spy = class_spy(Facts::Windows::NetworkInterfaces)
      windows_networking_interface = instance_spy(Facts::Windows::NetworkInterfaces)

      resolved_fact = mock_resolved_fact('network_Ethernet0', '192.168.5.121', nil, [], :legacy)

      allow(networking_interface_class_spy).to receive(:new).and_return(windows_networking_interface)
      allow(windows_networking_interface).to receive(:call_the_resolver).and_return(resolved_fact)

      searched_fact = instance_spy(Facter::SearchedFact, name: 'network_.*', fact_class: networking_interface_class_spy,
                                                         filter_tokens: [], user_query: '', type: :core)

      core_fact_manager = Facter::InternalFactManager.new
      resolved_facts = core_fact_manager.resolve_facts([searched_fact])

      expect(resolved_facts).to eq([resolved_fact])
    end
  end
end
