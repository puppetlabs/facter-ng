# frozen_string_literal: true

describe Facter::Options do
  let(:options) { Facter::Options.get }

  before do
    # Facter::Options.initialize_options
  end

  describe '#augment_with_defaults!' do
    before do
      Facter::Options.augment_with_defaults!
    end

    it 'sets debug to false' do
      expect(Facter::Options[:debug]).to be_falsey
    end

    it 'sets trace to false' do
      expect(Facter::Options[:trace]).to be_falsey
    end

    it 'sets verbose to false' do
      expect(Facter::Options[:verbose]).to be_falsey
    end

    it 'sets log_level to warn' do
      expect(Facter::Options[:log_level]).to eq(:warn)
    end

    it 'sets show_legacy to false' do
      expect(Facter::Options[:show_legacy]).to be_falsey
    end

    it 'set custom-dir with empty array' do
      expect(Facter::Options[:custom_dir].size).to eq(0)
    end

    it 'sets external-dir with empty array' do
      expect(Facter::Options[:external_dir].size).to eq(0)
    end

    it 'sets ruby to true' do
      expect(Facter::Options[:ruby]).to be_truthy
    end
  end

  describe '#augment_with_config_file_options!' do
    context 'sets options from config file with cli' do
      let(:config_reader_double) { double(Facter::ConfigReader) }
      let(:block_list_double) { double(Facter::BlockList) }

      before do
        Facter::Options[:cli] = true
        allow(Facter::ConfigReader).to receive(:new).with('config_path').and_return(config_reader_double)
        allow(config_reader_double).to receive(:cli).and_return(
          'debug' => false, 'trace' => true, 'verbose' => true, 'log-level' => :warn
        )

        allow(config_reader_double).to receive(:global).and_return(
          'no-custom-facts' => false, 'custom-dir' => %w[custom_dir1 custom_dir2],
          'no-external-facts' => false, 'external-dir' => %w[external_dir1 external_dir2],
          'no-ruby' => false, 'show-legacy' => true
        )
        allow(config_reader_double).to receive(:ttls).and_return([{ 'timezone' => '30 days' }])

        allow(Facter::BlockList).to receive(:instance).and_return(block_list_double)
        allow(block_list_double).to receive(:blocked_facts).and_return(%w[block_fact1 blocked_fact2])

        Facter::Options.augment_with_config_file_options!('config_path')
      end

      it 'sets debug to true' do
        expect(Facter::Options[:debug]).to be_falsey
      end

      it 'sets trace to true' do
        expect(Facter::Options[:trace]).to be_truthy
      end

      it 'sets verbose to true' do
        expect(Facter::Options[:verbose]).to be_truthy
      end

      it 'sets logs level to error' do
        expect(Facter::Options[:log_level]).to eq(:warn)
      end

      it 'sets custom-facts to true' do
        expect(Facter::Options[:custom_facts]).to be_truthy
      end

      it 'sets custom-dir' do
        expect(Facter::Options[:custom_dir]).to eq(%w[custom_dir1 custom_dir2])
      end

      it 'sets external-facts to true' do
        expect(Facter::Options[:external_facts]).to be_truthy
      end

      it 'sets external-dir' do
        expect(Facter::Options[:external_dir]).to eq(%w[external_dir1 external_dir2])
      end

      it 'sets ruby to true' do
        expect(Facter::Options[:ruby]).to be_truthy
      end

      it 'sets show_legacy to true' do
        expect(Facter::Options[:show_legacy]).to be_truthy
      end

      it 'sets blocked_facts' do
        expect(Facter::Options[:blocked_facts]).to eq(%w[block_fact1 blocked_fact2])
      end

      it 'sets ttls' do
        expect(Facter::Options[:ttls]).to eq([{ 'timezone' => '30 days' }])
      end
    end

    context 'sets options from config file with no cli' do
      let(:config_reader_double) { double(Facter::ConfigReader) }
      let(:block_list_double) { double(Facter::BlockList) }

      before do
        allow(Facter::ConfigReader).to receive(:new).with('config_path').and_return(config_reader_double)
        allow(config_reader_double).to receive(:cli).and_return(
          'debug' => false, 'trace' => true, 'verbose' => true, 'log-level' => :warn
        )

        allow(config_reader_double).to receive(:global).and_return(
          'no-custom-facts' => false, 'custom-dir' => %w[custom_dir1 custom_dir2],
          'no-external-facts' => false, 'external-dir' => %w[external_dir1 external_dir2],
          'no-ruby' => false, 'show-legacy' => true
        )
        allow(config_reader_double).to receive(:ttls).and_return([{ 'timezone' => '30 days' }])

        allow(Facter::BlockList).to receive(:instance).and_return(block_list_double)
        allow(block_list_double).to receive(:blocked_facts).and_return(%w[block_fact1 blocked_fact2])

        Facter::Options.augment_with_config_file_options!('config_path')
      end

      it 'sets debug to nil' do
        expect(Facter::Options[:debug]).to be_falsey
      end

      it 'sets trace to nil' do
        expect(Facter::Options[:trace]).to be_falsey
      end

      it 'sets verbose to nil' do
        expect(Facter::Options[:verbose]).to be_falsey
      end

      it 'sets logs level to nil' do
        expect(Facter::Options[:log_level]).to eq(:warn)
      end

      it 'sets custom-facts to nil' do
        expect(Facter::Options[:custom_facts]).to be_nil
      end

      it 'sets custom-dir' do
        expect(Facter::Options[:custom_dir]).to eq(%w[custom_dir1 custom_dir2])
      end

      it 'sets external-facts to nil' do
        expect(Facter::Options[:external_facts]).to be_nil
      end

      it 'sets external-dir' do
        expect(Facter::Options[:external_dir]).to eq(%w[external_dir1 external_dir2])
      end

      it 'sets ruby to nil' do
        expect(Facter::Options[:ruby]).to be_nil
      end

      it 'sets show_legacy to true' do
        expect(Facter::Options[:show_legacy]).to be_truthy
      end

      it 'sets blocked_facts' do
        expect(Facter::Options[:blocked_facts]).to eq(%w[block_fact1 blocked_fact2])
      end

      it 'sets ttls' do
        expect(Facter::Options[:ttls]).to eq([{ 'timezone' => '30 days' }])
      end
    end

    context 'override default options' do
      let(:config_reader_double) { double(Facter::ConfigReader) }
      let(:block_list_double) { double(Facter::BlockList) }

      before do
        allow(Facter::ConfigReader).to receive(:new).with('config_path').and_return(config_reader_double)
        allow(config_reader_double).to receive(:cli).and_return(
          'debug' => true, 'trace' => true
        )

        allow(config_reader_double).to receive(:global).and_return(
          'no-custom-facts' => true, 'no-external-facts' => true, 'no-ruby' => true
        )

        allow(config_reader_double).to receive(:ttls).and_return([{ 'timezone' => '30 days' }])

        allow(Facter::BlockList).to receive(:instance).and_return(block_list_double)
        allow(block_list_double).to receive(:blocked_facts).and_return(%w[block_fact1 blocked_fact2])

        Facter::Options.augment_with_config_file_options!('config_path')
      end

      it 'sets debug to true' do
        expect(Facter::Options[:debug]).to be_truthy
      end

      it 'sets trace to true' do
        expect(Facter::Options[:trace]).to be_truthy
      end

      it 'sets custom-facts to true' do
        expect(Facter::Options[:custom_facts]).to be_falsey
      end

      it 'sets external-facts to true' do
        expect(Facter::Options[:external_facts]).to be_falsey
      end

      it 'sets ruby to true' do
        expect(Facter::Options[:ruby]).to be_falsey
      end

      it 'sets blocked_facts' do
        expect(Facter::Options[:blocked_facts]).to eq(%w[block_fact1 blocked_fact2])
      end

      it 'sets ttls' do
        expect(Facter::Options[:ttls]).to eq([{ 'timezone' => '30 days' }])
      end
    end
  end

  context 'override default options log_level' do
    let(:config_reader_double) { double(Facter::ConfigReader) }
    let(:block_list_double) { double(Facter::BlockList) }

    before do
      allow(Facter::ConfigReader).to receive(:new).with('config_path').and_return(config_reader_double)
      allow(config_reader_double).to receive(:cli).and_return('log-level' => :err)
      allow(config_reader_double).to receive(:global).and_return(
        'no-custom-facts' => true, 'no-external-facts' => true, 'no-ruby' => true
      )

      allow(config_reader_double).to receive(:ttls).and_return([{ 'timezone' => '30 days' }])

      allow(Facter::BlockList).to receive(:instance).and_return(block_list_double)
      allow(block_list_double).to receive(:blocked_facts).and_return(%w[block_fact1 blocked_fact2])

      Facter::Options.augment_with_defaults!
      Facter::Options.augment_with_config_file_options!('config_path')
    end

    it 'sets debug to true' do
      expect(Facter::Options[:debug]).to be_falsey
    end

    it 'sets trace to true' do
      expect(Facter::Options[:trace]).to be_falsey
    end

    it 'sets verbose to true' do
      expect(Facter::Options[:verbose]).to be_falsey
    end

    it 'sets logs level to error' do
      expect(Facter::Options[:log_level]).to eq(:err)
    end
  end

  context 'log_level option conflict in config file' do
    let(:config_reader_double) { double(Facter::ConfigReader) }
    let(:block_list_double) { double(Facter::BlockList) }
    let(:log) { instance_spy(Facter::Log) }

    before do
      allow(Facter::ConfigReader).to receive(:new).with('config_path').and_return(config_reader_double)
      allow(config_reader_double).to receive(:cli).and_return('debug' => true, 'verbose' => true)
      allow(config_reader_double).to receive(:global).and_return(
        'no-custom-facts' => true, 'no-external-facts' => true, 'no-ruby' => true
      )

      allow(config_reader_double).to receive(:ttls).and_return([{ 'timezone' => '30 days' }])

      allow(Facter::BlockList).to receive(:instance).and_return(block_list_double)
      allow(block_list_double).to receive(:blocked_facts).and_return(%w[block_fact1 blocked_fact2])

      allow(Facter::Log).to receive(:new).and_return(log)
      allow(log).to receive(:error).with(
        'debug, verbose, and log-level options conflict: please specify only one.', true
      )
      allow(Facter::Cli).to receive(:start).with(['--help'])
    end

    it 'prints help and exit' do
      expect { Facter::Options.initialize_options_from_cli(config: 'config_path') }.to raise_error(SystemExit)
    end
  end

  describe '#augment_with_cli_options!' do
    before do
      Facter::Options.augment_with_defaults!
      cli_options = { 'ruby' => false, 'external_facts' => false, 'custom_dir' => ['custom_dir'] }
      Facter::Options.initialize_options_from_cli(cli_options)
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
      Facter::Options.augment_with_defaults!
      cli_options = { 'ruby' => false, 'external_dir' => 'external_dir' }
      Facter::Options.initialize_options_from_cli(cli_options)
      Facter::Options[:user_query] = %w[first_user_query second_user_query]
    end

    it 'sets user_query to true' do
      expect(Facter::Options[:user_query]).to be_truthy
    end

    it 'sets custom_facts to false' do
      expect(Facter::Options[:custom_facts]).to be_falsey
    end

    it 'adds ruby to block list' do
      expect(Facter::Options[:blocked_facts]).to include('ruby')
    end

    it 'converts external dir string to array' do
      expect(Facter::Options[:external_dir]).to eq(['external_dir'])
    end
  end

  describe '#get' do
    before do
      cli_options = { 'ruby' => true }
      Facter::Options.initialize_options_from_cli(cli_options)
    end

    it 'sets ruby option' do
      expect(Facter::Options.get).to include(ruby: true)
    end
  end

  describe '#custom_dir?' do
    context 'custom dir is true' do
      before do
        cli_options = { 'custom_facts' => true, 'custom_dir' => %w[custom_dir1 custom_dir2] }
        Facter::Options.initialize_options_from_cli(cli_options)
      end

      it 'returns that custom dir exists' do
        expect(Facter::Options).to be_custom_dir
      end
    end

    context 'custom dir is false' do
      before do
        cli_options = { 'custom_facts' => false, 'custom_dir' => %w[custom_dir1 custom_dir2] }
        Facter::Options.initialize_options_from_cli(cli_options)
      end

      it 'returns that custom dir dos not exists' do
        expect(Facter::Options).not_to be_custom_dir
      end
    end
  end

  describe '#customn_dir' do
    before do
      cli_options = { 'custom_dir' => %w[custom_dir1 custom_dir2] }
      Facter::Options.initialize_options_from_cli(cli_options)
    end

    it 'returns custom dirs' do
      expect(Facter::Options.custom_dir).to eq(%w[custom_dir1 custom_dir2])
    end
  end

  describe '#external_dir?' do
    context 'external dir is true' do
      before do
        cli_options = { 'external_facts' => true, 'external_dir' => %w[external_dir1 external_dir2] }
        Facter::Options.initialize_options_from_cli(cli_options)
      end

      it 'returns that external dir exists' do
        expect(Facter::Options).to be_external_dir
      end
    end

    context 'external dir is false' do
      before do
        cli_options = { 'external_facts' => false, 'external_dir' => %w[external_dir1 external_dir2] }
        Facter::Options.initialize_options_from_cli(cli_options)
      end

      it 'returns that external dir does not exists' do
        expect(Facter::Options).not_to be_external_dir
      end
    end
  end

  describe '#external_dir' do
    before do
      cli_options = { 'external_dir' => %w[external_dir1 external_dir2] }
      Facter::Options.initialize_options_from_cli(cli_options)
    end

    it 'returns external dirs' do
      expect(Facter::Options.external_dir).to eq(%w[external_dir1 external_dir2])
    end
  end

  describe '#verbose' do
    before do
      cli_options = { 'verbose' => true }
      Facter::Options.initialize_options_from_cli(cli_options)

      Facter::Options.augment_with_helper_options!([])
    end

    it 'returns log_level info' do
      expect(Facter::Options[:log_level]).to eq(:info)
    end
  end

  # describe '#refresh' do
  #   before do
  #     cli_options = { 'external_dir' => %w[external_dir1 external_dir2] }
  #   end

  #   let(:subject) { Facter::Options }

  #   context 'with persistent options' do
  #     it 'sets debug to true' do
  #       subject.priority_options = { debug: true }
  #       expect(subject.refresh[:debug]).to eq(true)
  #     end

  #     it 'sets debug to false' do
  #       subject.priority_options = { debug: false }
  #       expect(subject.refresh[:debug]).to eq(false)
  #     end
  #   end

  #   context 'priority options have the highest priority' do
  #     before do
  #       Facter::Options.augment_with_defaults!
  #     end

  #     let(:subject) { Facter::Options }

  #     it 'sets debug to true' do
  #       expect(subject.refresh[:debug]).to eq(false)
  #     end

  #     it 'sets debug to false' do
  #       subject.priority_options = { debug: false }
  #       expect(subject.refresh[:debug]).to eq(false)
  #     end
  #   end
  # end
end
