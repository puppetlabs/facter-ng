# frozen_string_literal: true

describe 'ConfigReader' do
  describe '#refresh_config' do
    context 'read config' do
      it 'uses facter.conf' do
        expect(Hocon).to receive(:load).with('facter.conf')
        Facter::ConfigReader.new
      end

      it 'uses provided existing file' do
        expect(File).to receive(:file?).with('/my_conf.conf').and_return(true)
        expect(Hocon).to receive(:load).with('/my_conf.conf')
        Facter::ConfigReader.new('/my_conf.conf')
      end

      it 'uses provided inexistent file' do
        expect(File).to receive(:file?).with('/my_conf.conf').and_return(false)
        expect(Hocon).not_to receive(:load)
        Facter::ConfigReader.new('/my_conf.conf')
      end
    end
  end

  describe '#block_list' do
    it 'loads block list' do
      expect(Hocon).to receive(:load).with('facter.conf').and_return('facts' => { 'blocklist' => %w[group1 fact1] })
      config_reader = Facter::ConfigReader.new
      expect(config_reader.block_list).to eq(%w[group1 fact1])
    end

    it 'finds no facts' do
      expect(Hocon).to receive(:load).with('facter.conf').and_return({})
      config_reader = Facter::ConfigReader.new

      expect(config_reader.ttls).to be_nil
    end

    it 'finds no block list' do
      expect(Hocon).to receive(:load).with('facter.conf').and_return({})
      config_reader = Facter::ConfigReader.new
      expect(config_reader.block_list).to be_nil
    end
  end

  describe '#ttls' do
    it 'loads ttls' do
      expect(Hocon)
        .to receive(:load)
        .with('facter.conf')
        .and_return('facts' => { 'ttls' => [{ 'fact_name' => '10 days' }] })

      config_reader = Facter::ConfigReader.new
      expect(config_reader.ttls).to eq([{ 'fact_name' => '10 days' }])
    end

    it 'finds no facts' do
      expect(Hocon).to receive(:load).with('facter.conf').and_return({})
      config_reader = Facter::ConfigReader.new

      expect(config_reader.ttls).to be_nil
    end

    it 'finds no ttls' do
      expect(Hocon).to receive(:load).with('facter.conf').and_return('facts' => {})
      config_reader = Facter::ConfigReader.new

      expect(config_reader.ttls).to be_nil
    end
  end

  describe '#global' do
    it 'loads global config' do
      expect(Hocon).to receive(:load).with('facter.conf').and_return('global' => 'global_config')
      config_reader = Facter::ConfigReader.new

      expect(config_reader.global).to eq('global_config')
    end

    it 'finds no global config' do
      expect(Hocon).to receive(:load).with('facter.conf').and_return({})
      config_reader = Facter::ConfigReader.new

      expect(config_reader.global).to be_nil
    end
  end

  describe '#cli' do
    it 'loads cli config' do
      expect(Hocon).to receive(:load).with('facter.conf').and_return('cli' => 'cli_config')
      config_reader = Facter::ConfigReader.new

      expect(config_reader.cli).to eq('cli_config')
    end

    it 'finds no global config' do
      expect(Hocon).to receive(:load).with('facter.conf').and_return({})
      config_reader = Facter::ConfigReader.new

      expect(config_reader.cli).to be_nil
    end
  end
end
