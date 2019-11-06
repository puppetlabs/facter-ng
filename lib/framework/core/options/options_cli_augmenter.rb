module Facter
  class OptionsCliAugmenter
    def initialize
      @config_reader = Facter::ConfigReader.instance
    end

    def augment!(options)
       options[:debug] = @config_reader.cli['debug'] unless  options[:debug]
       options[:trace] = @config_reader.cli['trace'] unless  options[:trace]
       options[:verbose] = @config_reader.cli['verbose'] unless  options[:verbose]
       options[:log_level] = @config_reader.cli['log-level'] unless  options[:log_level]
    end
  end
end
