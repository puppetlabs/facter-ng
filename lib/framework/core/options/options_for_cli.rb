module Facter
  class OptionsForCli
    def initialize(options)
      @options = options
      @config_reader = Facter::ConfigReader.instance
      augment!
    end

    def [](key)
      @options[key]
    end

    def []=(key, value)
      @options[key] = value
    end

    private

    def augment!
      @options[:debug] = @config_reader.cli['debug'] unless @options[:debug]
      @options[:trace] = @config_reader.cli['trace'] unless @options[:trace]
      @options[:verbose] = @config_reader.cli['verbose'] unless @options[:verbose]
      @options[:log_level] = @config_reader.cli['log-level'] unless @options[:log_level]
    end
  end
end
