require 'rbconfig'

# A module to return config related data
#
module Facter
  module Util
    module Config
      def self.ext_fact_loader
        @ext_fact_loader || Facter::Util::DirectoryLoader.default_loader
      end

      def self.ext_fact_loader=(loader)
        @ext_fact_loader = loader
      end

      def self.is_mac?
        RbConfig::CONFIG['host_os'] =~ /darwin/i
      end

      # Returns true if OS is windows
      def self.is_windows?
        RbConfig::CONFIG['host_os'] =~ /mswin|win32|dos|mingw|cygwin/i
      end

      def self.windows_data_dir
        if Facter::Util::Config.is_windows?
          Facter::Util::Windows::Dir.get_common_appdata()
        else
          nil
        end
      end

      def self.external_facts_dirs=(dir)
        @external_facts_dirs = dir
      end

      def self.external_facts_dirs
        @external_facts_dirs
      end

      def self.setup_default_ext_facts_dirs
        if Facter::Util::Root.root?
          windows_dir = windows_data_dir
          if windows_dir.nil? then
            # Note: Beginning with Facter 3, /opt/puppetlabs/custom_facts/facts.d will be the only
            # default external fact directory.
            @external_facts_dirs = ["/opt/puppetlabs/custom_facts/facts.d",
                                    "/etc/custom_facts/facts.d",
                                    "/etc/puppetlabs/custom_facts/facts.d"]
          else
            @external_facts_dirs = [File.join(windows_dir, 'PuppetLabs', 'custom_facts', 'facts.d')]
          end
        elsif ENV['HOME']
          # Note: Beginning with Facter 3, ~/.puppetlabs/opt/custom_facts/facts.d will be the only
          # default external fact directory.
          @external_facts_dirs = [File.expand_path(File.join(ENV['HOME'], ".puppetlabs", "opt", "custom_facts", "facts.d")),
                                  File.expand_path(File.join(ENV['HOME'], ".custom_facts", "facts.d"))]
        else
          @external_facts_dirs = []
        end
      end

      if Facter::Util::Config.is_windows?
        require_relative 'custom_facts/util/windows/dir'
        require_relative 'custom_facts/util/windows_root'
      else
        require_relative 'unix_root'
      end

      setup_default_ext_facts_dirs

      def self.override_binary_dir=(dir)
        @override_binary_dir = dir
      end

      def self.override_binary_dir
        @override_binary_dir
      end

      def self.setup_default_override_binary_dir
        if Facter::Util::Config.is_windows?
          @override_binary_dir = nil
        else
          @override_binary_dir = "/opt/puppetlabs/puppet/bin"
        end
      end

      setup_default_override_binary_dir
    end
  end
end
