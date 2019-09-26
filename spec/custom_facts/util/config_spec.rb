#! /usr/bin/env ruby

require_relative '../../spec_helper_legacy'

describe Facter::Util::Config do
  include PuppetlabsSpec::Files

  describe "ENV['HOME'] is unset", :unless => Facter::Util::Root.root? do
    around do |example|
      Facter::Core::Execution.with_env('HOME' => nil) do
        example.run
      end
    end

    it "should not set @external_facts_dirs" do
      Facter::Util::Config.setup_default_ext_facts_dirs
      expect(Facter::Util::Config.external_facts_dirs).to be_empty
    end
  end

  describe "is_windows? function" do
    it "should detect windows if Ruby RbConfig::CONFIG['host_os'] returns a windows OS" do
      host_os = ["mswin","win32","dos","mingw","cygwin"]
      host_os.each do |h|
        RbConfig::CONFIG.stubs(:[]).with('host_os').returns(h)
        expect(Facter::Util::Config.is_windows?).to be_truthy
      end
    end

    it "should not detect windows if Ruby RbConfig::CONFIG['host_os'] returns a non-windows OS" do
      host_os = ["darwin","linux"]
      host_os.each do |h|
        RbConfig::CONFIG.stubs(:[]).with('host_os').returns(h)
        expect(Facter::Util::Config.is_windows?).to be_falsey
      end
    end
  end

  describe "is_mac? function" do
    it "should detect mac if Ruby RbConfig::CONFIG['host_os'] returns darwin" do
      host_os = ["darwin"]
      host_os.each do |h|
        RbConfig::CONFIG.stubs(:[]).with('host_os').returns(h)
        expect(Facter::Util::Config.is_mac?).to be_truthy
      end
    end
  end

  describe "external_facts_dirs" do
    before :each do
      Facter::Util::Root.stubs(:root?).returns(true)
    end

    it "should return the default value for linux" do
      Facter::Util::Config.stubs(:is_windows?).returns(false)
      Facter::Util::Config.stubs(:windows_data_dir).returns(nil)
      Facter::Util::Config.setup_default_ext_facts_dirs
      expect(Facter::Util::Config.external_facts_dirs).to eq ["/opt/puppetlabs/custom_facts/facts.d", "/etc/custom_facts/facts.d", "/etc/puppetlabs/custom_facts/facts.d"]
    end

    it "should return the default value for windows 2008" do
      Facter::Util::Config.stubs(:is_windows?).returns(true)
      Facter::Util::Config.stubs(:windows_data_dir).returns("C:\\ProgramData")
      Facter::Util::Config.setup_default_ext_facts_dirs
      expect(Facter::Util::Config.external_facts_dirs).to eq [File.join("C:\\ProgramData", 'PuppetLabs', 'custom_facts', 'facts.d')]
    end

    it "should return the default value for windows 2003R2" do
      Facter::Util::Config.stubs(:is_windows?).returns(true)
      Facter::Util::Config.stubs(:windows_data_dir).returns("C:\\Documents")
      Facter::Util::Config.setup_default_ext_facts_dirs
      expect(Facter::Util::Config.external_facts_dirs).to eq [File.join("C:\\Documents", 'PuppetLabs', 'custom_facts', 'facts.d')]
    end

    it "returns the old and new (AIO) paths under user's home directory when not root" do
      Facter::Util::Root.stubs(:root?).returns(false)
      Facter::Util::Config.setup_default_ext_facts_dirs
      expect(Facter::Util::Config.external_facts_dirs)
        .to eq [File.expand_path(File.join("~", ".puppetlabs", "opt", "custom_facts", "facts.d")),
            File.expand_path(File.join("~", ".custom_facts", "facts.d"))]
    end

    it "includes additional values when user appends to the list" do
      Facter::Util::Config.setup_default_ext_facts_dirs
      original_values = Facter::Util::Config.external_facts_dirs.dup
      new_value = '/usr/share/newdir'
      Facter::Util::Config.external_facts_dirs << new_value
      expect(Facter::Util::Config.external_facts_dirs).to eq original_values + [new_value]
    end

    it "should only output new values when explicitly set" do
      Facter::Util::Config.setup_default_ext_facts_dirs
      new_value = ['/usr/share/newdir']
      Facter::Util::Config.external_facts_dirs = new_value
      expect(Facter::Util::Config.external_facts_dirs).to eq new_value
    end

  end

  describe "override_binary_dir" do
    it "should return the default value for linux" do
      Facter::Util::Config.stubs(:is_windows?).returns(false)
      Facter::Util::Config.setup_default_override_binary_dir
      expect(Facter::Util::Config.override_binary_dir).to eq "/opt/puppetlabs/puppet/bin"
    end

    it "should return nil for windows" do
      Facter::Util::Config.stubs(:is_windows?).returns(true)
      Facter::Util::Config.setup_default_override_binary_dir
      expect(Facter::Util::Config.override_binary_dir).to eq nil
    end

    it "should output new values when explicitly set" do
      Facter::Util::Config.setup_default_override_binary_dir
      new_value = '/usr/share/newdir'
      Facter::Util::Config.override_binary_dir = new_value
      expect(Facter::Util::Config.override_binary_dir).to eq new_value
    end
  end

end
