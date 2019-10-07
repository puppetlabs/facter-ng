# frozen_string_literal: true

describe 'QueryParser' do
  describe '#parse' do
    it 'creates one core searched fact' do
      query_list = ['os.name']

      os_class = Class.const_get('Facter::Ubuntu::OsName')
      os_name = Class.const_get('Facter::Ubuntu::OsFamily')
      loaded_facts_hash = { 'os.name' => os_class,
                            'os.family' => os_name }
      matched_facts = Facter::QueryParser.parse(query_list, loaded_facts_hash)

      expect(matched_facts.size).to eq(1)
      expect(matched_facts.first.fact_class).to eq(os_class)
    end

    it 'creates one legacy fact' do
      query_list = ['ipaddress_ens160']

      networking_class = Class.const_get('Facter::Ubuntu::NetworkInterface')
      os_name = Class.const_get('Facter::Ubuntu::OsFamily')
      loaded_facts_hash = { 'ipaddress_.*' => networking_class,
                            'os.family' => os_name }
      matched_facts = Facter::QueryParser.parse(query_list, loaded_facts_hash)

      expect(matched_facts.size).to eq(1)
      expect(matched_facts.first.fact_class).to eq(networking_class)
    end

    it 'creates one custom searched fact' do
      query_list = ['custom_Fact']

      os_class = Class.const_get('Facter::Ubuntu::OsName')
      os_name = Class.const_get('Facter::Ubuntu::OsFamily')
      loaded_facts_hash = { 'os.name' => os_class,
                            'os.family' => os_name }
      matched_facts = Facter::QueryParser.parse(query_list, loaded_facts_hash)

      expect(matched_facts.size).to eq(1)
      expect(matched_facts.first.fact_class).to  be_nil
    end
  end
end
