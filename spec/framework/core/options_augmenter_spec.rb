# frozen_string_literal: true

describe 'OptionsAugmenter' do
  before do
    Singleton.__init__(Facter::ConfigReader)
    Singleton.__init__(Facter::BlockList)
  end

  describe '#augment_with_cli_options' do
    it 'augments with cli options' do
      cli_config = { 'debug' => false, 'trace' => false, 'verbose' => false, 'log-level' => 'info' }
      allow_any_instance_of(Facter::ConfigReader).to receive('cli').and_return(cli_config)

      options_augmenter = Facter::OptionsAugmenter.new({})
      options_augmenter.augment_with_cli_options!
      augmented_options = options_augmenter.options

      expect(augmented_options[:debug]).to eq(false)
      expect(augmented_options[:trace]).to eq(false)
      expect(augmented_options[:verbose]).to eq(false)
      expect(augmented_options[:log_level]).to eq('info')
    end

    it 'augments with global options' do
      global_config = { 'external-dir' => 'external_dir_value', 'custom-dir' => 'cust_dir_value',
                        'no-external-facts' => false, 'no-custom-facts' => false,
                        'no-ruby' => false}
      allow_any_instance_of(Facter::ConfigReader).to receive('global').and_return(global_config)

      options_augmenter = Facter::OptionsAugmenter.new({})
      options_augmenter.augment_with_global_options!
      augmented_options = options_augmenter.options

      expect(augmented_options[:external_dir]).to eq('external_dir_value')
      expect(augmented_options[:custom_dir]).to eq('cust_dir_value')
      expect(augmented_options[:no_custom_facts]).to eq(false)
      expect(augmented_options[:no_external_facts]).to eq(false)
      expect(augmented_options[:no_ruby]).to eq(false)
    end

    it 'augments with facter options' do
      fact_config = [{'fact' => '13 days'}]
      block_fact_list = ['fact1', 'fact2', 'fact3']
      allow_any_instance_of(Facter::ConfigReader).to receive('ttls').and_return(fact_config)
      allow_any_instance_of(Facter::BlockList).to receive(:block_groups_to_facts).and_return(block_fact_list)

      options_augmenter = Facter::OptionsAugmenter.new({})
      options_augmenter.augment_with_facts_options!
      augmented_options = options_augmenter.options

      expect(augmented_options[:ttls]).to eq([{'fact' => '13 days'}])
      expect(augmented_options[:block_facts]).to eq(['fact1', 'fact2', 'fact3'])
    end

    it 'augments with query options' do
      options_augmenter = Facter::OptionsAugmenter.new({})
      options_augmenter.augment_with_query_options!(['os'])

      augmented_options = options_augmenter.options
      expect(augmented_options[:user_query]).to eq(true)
    end
  end
end
