require 'hocon'
require 'singleton'

module Facter
  class ConfigReader
    include Singleton

    attr_accessor :conf

    def initialize(config_path = nil)
      @config_file_path = config_path || 'facter.conf'
    end

    def block_list
      load_config
      @conf['facts']['blocklist']
    end

    def ttls
      load_config
      @conf['facts']['ttls']
    end

    def global
      load_config
      @conf['global']
    end

    def cli
      load_config
      @conf['cli']
    end

    private

    def load_config
      @conf = Hocon.load(@config_file_path)
    end
  end
end
