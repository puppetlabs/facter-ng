# frozen_string_literal: true

module Facter
  class ConfigReader
    attr_accessor :conf

    def initialize(config_path = nil)
      os = CurrentOs.instance.identifier

      # puts "#{os}"
      path = os == :windows ? File.join('C:','ProgramData' ,'PuppetLabs', 'facter', 'etc', 'facter.conf') : '/etc/puppetlabs/facter/facter.conf'
      # puts "#{path}"
      @config_file_path = config_path || path
      refresh_config
    end

    def block_list
      @conf['facts'] && @conf['facts']['blocklist']
    end

    def ttls
      @conf['facts'] && @conf['facts']['ttls']
    end

    def global
      # puts @conf['global']
      @conf['global']
    end

    def cli
      @conf['cli']
    end

    def refresh_config
      @conf = File.exist?(@config_file_path) ? Hocon.load(@config_file_path) : {}
    end
  end
end
