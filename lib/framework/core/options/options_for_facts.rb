module Facter
  class OptionsForFacts
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
      @options[:block_facts] = Facter::BlockList.instance.block_groups_to_facts
      @options[:ttls] = @config_reader.ttls
    end
  end
end
