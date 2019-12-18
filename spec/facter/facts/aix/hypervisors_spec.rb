# frozen_string_literal: true

describe 'Aix Hypervisors' do
  context '#call_the_resolver' do
    it 'returns a lpar only hypervisor fact' do
      expected_fact_name = 'hypervisors'
      expected_fact_value = { 'lpar' => { partition_number: 13, partition_name: 'aix6-7' } }
      allow(Facter::Resolvers::Lpar).to receive(:resolve).with(:lpar_partition_number).and_return(13)
      allow(Facter::Resolvers::Lpar).to receive(:resolve).with(:lpar_partition_name).and_return('aix6-7')
      allow(Facter::Resolvers::Lpar).to receive(:resolve).with(:wpar_key).and_return(nil)
      allow(Facter::Resolvers::Lpar).to receive(:resolve).with(:wpar_configured_id).and_return(nil)

      fact = Facter::Aix::Hypervisors.new.call_the_resolver

      expect(fact.name).to eq(expected_fact_name)
      expect(fact.value).to eq(expected_fact_value)
    end
    it 'returns a wpar only hypervisor fact' do
      expected_fact_name = 'hypervisors'
      expected_fact_value = { 'wpar' => { key: 13, configured_id: 14 } }
      allow(Facter::Resolvers::Lpar).to receive(:resolve).with(:lpar_partition_number).and_return(nil)
      allow(Facter::Resolvers::Lpar).to receive(:resolve).with(:lpar_partition_name).and_return(nil)
      allow(Facter::Resolvers::Lpar).to receive(:resolve).with(:wpar_key).and_return(13)
      allow(Facter::Resolvers::Lpar).to receive(:resolve).with(:wpar_configured_id).and_return(14)

      fact = Facter::Aix::Hypervisors.new.call_the_resolver

      expect(fact.name).to eq(expected_fact_name)
      expect(fact.value).to eq(expected_fact_value)
    end
    it 'returns a wpar and lpar hypervisor fact' do
      expected_fact_name = 'hypervisors'
      expected_fact_value = { 'wpar' => { key: 13, configured_id: 14 },
                              'lpar' => { partition_number: 13, partition_name: 'aix6-7' } }
      allow(Facter::Resolvers::Lpar).to receive(:resolve).with(:lpar_partition_number).and_return(13)
      allow(Facter::Resolvers::Lpar).to receive(:resolve).with(:lpar_partition_name).and_return('aix6-7')
      allow(Facter::Resolvers::Lpar).to receive(:resolve).with(:wpar_key).and_return(13)
      allow(Facter::Resolvers::Lpar).to receive(:resolve).with(:wpar_configured_id).and_return(14)

      fact = Facter::Aix::Hypervisors.new.call_the_resolver

      expect(fact.name).to eq(expected_fact_name)
      expect(fact.value).to eq(expected_fact_value)
    end
  end
end
