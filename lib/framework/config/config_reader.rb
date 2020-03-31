# frozen_string_literal: true

module Facter
  class ConfigReader
    attr_accessor :conf

    def initialize(config_path = nil)
      load_config(config_path)
    end

    def block_list
      @conf['facts'] && @conf['facts']['blocklist']
    end

    def ttls
      @conf['facts'] && @conf['facts']['ttls']
    end

    def global
      @conf['global']
    end

    def cli
      @conf['cli']
    end

    def load_config(config_path)
      config_file_path = config_path || default_path
      @conf = File.readable?(config_file_path) ? Hocon.load(config_file_path) : {}
    end

    private

    def default_path
      os = OsDetector.instance.identifier

      windows_path = File.join('C:', 'ProgramData', 'PuppetLabs', 'facter', 'etc', 'facter.conf')
      linux_path = File.join('/', 'etc', 'puppetlabs', 'facter', 'facter.conf')

      os == :windows ? windows_path : linux_path
    end
  end
end
