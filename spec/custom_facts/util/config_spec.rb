#! /usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../spec_helper_legacy'

describe LegacyFacter::Util::Config do
  include PuppetlabsSpec::Files

  describe "ENV['HOME'] is unset", unless: LegacyFacter::Util::Root.root? do
    around do |example|
      LegacyFacter::Core::Execution.with_env('HOME' => nil) do
        example.run
      end
    end

    it 'does not set @external_facts_dirs' do
      described_class.setup_default_ext_facts_dirs
      expect(described_class.external_facts_dirs).to be_empty
    end
  end

  describe 'is_windows? function' do
    it "detects windows if Ruby RbConfig::CONFIG['host_os'] returns a windows OS" do
      host_os = %w[mswin win32 dos mingw cygwin]
      host_os.each do |h|
        allow(RbConfig::CONFIG).to receive(:[]).with('host_os').and_return(h)
        expect(described_class.windows?).to be_truthy
      end
    end

    it "does not detect windows if Ruby RbConfig::CONFIG['host_os'] returns a non-windows OS" do
      host_os = %w[darwin linux]
      host_os.each do |h|
        allow(RbConfig::CONFIG).to receive(:[]).with('host_os').and_return(h)
        expect(described_class.windows?).to be_falsey
      end
    end
  end

  describe 'is_mac? function' do
    it "detects mac if Ruby RbConfig::CONFIG['host_os'] returns darwin" do
      host_os = ['darwin']
      host_os.each do |h|
        allow(RbConfig::CONFIG).to receive(:[]).with('host_os').and_return(h)
        expect(described_class.mac?).to be_truthy
      end
    end
  end

  describe 'external_facts_dirs' do
    before do
      allow(LegacyFacter::Util::Root).to receive(:root?).and_return(true)
    end

    it 'returns the default value for linux' do
      allow(described_class).to receive(:windows?).and_return(false)
      allow(described_class).to receive(:windows_data_dir).and_return(nil)
      described_class.setup_default_ext_facts_dirs
      expect(described_class.external_facts_dirs)
        .to eq ['/opt/puppetlabs/facter/facts.d']
    end

    it 'returns the default value for windows 2008' do
      allow(described_class).to receive(:windows?).and_return(true)
      allow(described_class).to receive(:windows_data_dir).and_return('C:\\ProgramData')
      described_class.setup_default_ext_facts_dirs
      expect(described_class.external_facts_dirs)
        .to eq [File.join('C:\\ProgramData', 'PuppetLabs', 'facter', 'facts.d')]
    end

    it 'returns the default value for windows 2003R2' do
      allow(described_class).to receive(:windows?).and_return(true)
      allow(described_class).to receive(:windows_data_dir).and_return('C:\\Documents')
      described_class.setup_default_ext_facts_dirs
      expect(described_class.external_facts_dirs)
        .to eq [File.join('C:\\Documents', 'PuppetLabs', 'facter', 'facts.d')]
    end

    it "returns the old and new (AIO) paths under user's home directory when not root" do
      allow(LegacyFacter::Util::Root).to receive(:root?).and_return(false)
      described_class.setup_default_ext_facts_dirs
      expect(described_class.external_facts_dirs)
        .to eq [File.expand_path(File.join('~', '.puppetlabs', 'opt', 'facter', 'facts.d'))]
    end

    it 'includes additional values when user appends to the list' do
      described_class.setup_default_ext_facts_dirs
      original_values = described_class.external_facts_dirs.dup
      new_value = '/usr/share/newdir'
      described_class.external_facts_dirs << new_value
      expect(described_class.external_facts_dirs).to eq original_values + [new_value]
    end

    it 'onlies output new values when explicitly set' do
      described_class.setup_default_ext_facts_dirs
      new_value = ['/usr/share/newdir']
      described_class.external_facts_dirs = new_value
      expect(described_class.external_facts_dirs).to eq new_value
    end
  end

  describe 'override_binary_dir' do
    it 'returns the default value for linux' do
      allow(described_class).to receive(:windows?).and_return(false)
      described_class.setup_default_override_binary_dir
      expect(described_class.override_binary_dir).to eq '/opt/puppetlabs/puppet/bin'
    end

    it 'returns nil for windows' do
      allow(described_class).to receive(:windows?).and_return(true)
      described_class.setup_default_override_binary_dir
      expect(described_class.override_binary_dir).to eq nil
    end

    it 'outputs new values when explicitly set' do
      described_class.setup_default_override_binary_dir
      new_value = '/usr/share/newdir'
      described_class.override_binary_dir = new_value
      expect(described_class.override_binary_dir).to eq new_value
    end
  end
end
