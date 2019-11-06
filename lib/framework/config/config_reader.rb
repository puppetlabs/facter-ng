# frozen_string_literal: true

require 'hocon'
require 'singleton'

module Facter
  class ConfigReader
    attr_accessor :conf

    def initialize(config_path = nil)
      @config_file_path = config_path || 'facter.conf'
      refresh_config
    end

    def block_list
      refresh_config
      @conf['facts']['blocklist']
    end

    def ttls
      refresh_config
      @conf['facts']['ttls']
    end

    def global
      refresh_config
      @conf['global']
    end

    def cli
      refresh_config
      @conf['cli']
    end

    private

    def refresh_config
      @conf = Hocon.load(@config_file_path)
    end
  end
end
