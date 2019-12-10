# frozen_string_literal: true

describe 'OptionsAugmenter' do
  before do
    # Singleton.__init__(Facter::ConfigReader)
    # Singleton.__init__(Facter::BlockList)
    # Singleton.__init__(Facter::Options)
  end

  let(:options) { Facter::Options.instance.get }

  describe '#augment_with_defaults!' do
    before do
      Facter::Options.instance.augment_with_defaults!
    end

    it 'sets debug to false' do
      expect(options[:debug]).to be_falsey
    end

    it 'sets trace to false' do
      expect(options[:trace]).to be_falsey
    end

    it 'sets verbose to false' do
      expect(options[:verbose]).to be_falsey
    end

    it 'sets log_level to warn' do
      expect(options[:log_level]).to eq('warn')
    end

    it 'sets show_legacy to false' do
      expect(options[:show_legacy]).to be_falsey
    end

    it 'sets custom_facts to true' do
      expect(options[:custom_facts]).to be_truthy
    end

    it 'set custom-dir with empty array' do
      expect(options[:custom_dir].size).to eq(0)
    end

    it 'sets external_facts to true' do
      expect(options[:external_facts]).to be_truthy
    end

    it 'sets external-dir with empty array' do
      expect(options[:external_dir].size).to eq(0)
    end

    it 'sets ruby to true' do
      expect(options[:ruby]).to be_truthy
    end
  end

  describe '#augment_with_config_file_options!' do
    context 'sets options from config file' do
      let(:config_reader_double) { double(Facter::ConfigReader) }
      let(:block_list_double) { double(Facter::BlockList) }

      before do
        allow(Facter::ConfigReader).to receive(:new).with('config_path').and_return(config_reader_double)
        allow(config_reader_double).to receive(:cli).and_return(
          'debug' => true, 'trace' => true, 'verbose' => true, 'log-level' => 'err'
        )

        allow(config_reader_double).to receive(:global).and_return(
          'no-custom-facts' => false, 'custom-dir' => %w[custom_dir1 custom_dir2],
          'no-external-facts' => false, 'external-dir' => %w[external_dir1 external_dir2],
          'no-ruby' => false
        )
        allow(config_reader_double).to receive(:ttls).and_return([{ 'timezone' => '30 days' }])

        allow(Facter::BlockList).to receive(:instance).and_return(block_list_double)
        allow(block_list_double).to receive(:blocked_facts).and_return(%w[block_fact1 blocked_fact2])

        Facter::Options.instance.augment_with_config_file_options!('config_path')
      end

      it 'sets debug to true' do
        expect(options[:debug]).to be_truthy
      end

      it 'sets trace to true' do
        expect(options[:trace]).to be_truthy
      end

      it 'sets verbose to true' do
        expect(options[:verbose]).to be_truthy
      end

      it 'sets logs level to error' do
        expect(options[:log_level]).to eq('err')
      end

      it 'sets custom-facts to true' do
        expect(options[:custom_facts]).to be_truthy
      end

      it 'sets custom-dir' do
        expect(options[:custom_dir]).to eq(%w[custom_dir1 custom_dir2])
      end

      it 'sets external-facts to true' do
        expect(options[:external_facts]).to be_truthy
      end

      it 'sets external-dir' do
        expect(options[:external_dir]).to eq(%w[external_dir1 external_dir2])
      end

      it 'sets ruby to true' do
        expect(options[:ruby]).to be_truthy
      end

      it 'sets blocked_facts' do
        expect(options[:blocked_facts]).to eq(%w[block_fact1 blocked_fact2])
      end

      it 'sets ttls' do
        expect(options[:ttls]).to eq([{ 'timezone' => '30 days' }])
      end
    end

    context 'override default options' do
      let(:config_reader_double) { double(Facter::ConfigReader) }
      let(:block_list_double) { double(Facter::BlockList) }

      before do
        allow(Facter::ConfigReader).to receive(:new).with('config_path').and_return(config_reader_double)
        allow(config_reader_double).to receive(:cli).and_return(
          'debug' => true, 'trace' => true, 'verbose' => true, 'log-level' => 'err'
        )

        allow(config_reader_double).to receive(:global).and_return(
          'no-custom-facts' => true, 'no-external-facts' => true, 'no-ruby' => true
        )

        allow(config_reader_double).to receive(:ttls).and_return([{ 'timezone' => '30 days' }])

        allow(Facter::BlockList).to receive(:instance).and_return(block_list_double)
        allow(block_list_double).to receive(:blocked_facts).and_return(%w[block_fact1 blocked_fact2])

        Facter::Options.instance.augment_with_defaults!
        Facter::Options.instance.augment_with_config_file_options!('config_path')
      end

      it 'sets debug to true' do
        expect(options[:debug]).to be_truthy
      end

      it 'sets trace to true' do
        expect(options[:trace]).to be_truthy
      end

      it 'sets verbose to true' do
        expect(options[:verbose]).to be_truthy
      end

      it 'sets logs level to error' do
        expect(options[:log_level]).to eq('err')
      end

      it 'sets custom-facts to true' do
        expect(options[:custom_facts]).to be_falsey
      end

      it 'sets external-facts to true' do
        expect(options[:external_facts]).to be_falsey
      end

      it 'sets ruby to true' do
        expect(options[:ruby]).to be_falsey
      end

      it 'sets blocked_facts' do
        expect(options[:blocked_facts]).to eq(%w[block_fact1 blocked_fact2])
      end

      it 'sets ttls' do
        expect(options[:ttls]).to eq([{ 'timezone' => '30 days' }])
      end
    end
  end

  describe '#augment_with_cli_options!' do
    before do
      Facter::Options.instance.augment_with_defaults!
      cli_options = { 'ruby' => false, 'external_facts' => false, 'custom_dir' => ['custom_dir'] }
      Facter::Options.instance.augment_with_cli_options!(cli_options)
    end

    context 'override default with cli facts' do
      it 'sets ruby to true' do
        expect(options[:ruby]).to be_falsey
      end

      it 'sets external_facts to false' do
        expect(options[:external_facts]). to be_falsey
      end

      it 'sets custom_dir' do
        expect(options[:custom_dir]).to eq(['custom_dir'])
      end
    end
  end

  describe '#augment_with_helper_options!' do
    before do
      cli_options = { 'ruby' => false, 'external_dir' => 'external_dir' }
      Facter::Options.instance.augment_with_cli_options!(cli_options)
      Facter::Options.instance.augment_with_helper_options!(%w[first_user_query second_user_query])
    end

    it 'sets user_query to true' do
      expect(options[:user_query]).to be_truthy
    end

    it 'sets custom_facts to false' do
      expect(options[:custom_facts]).to be_falsey
    end

    it 'adds ruby to block list' do
      expect(options[:blocked_facts].include?('ruby')).to be_truthy
    end

    it 'converts external dir string to array' do
      expect(options[:external_dir]).to eq(['external_dir'])
    end
  end
end
