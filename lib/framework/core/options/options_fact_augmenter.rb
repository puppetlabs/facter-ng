
module Facter
  class OptionsFactAugmenter
    def initialize
      @config_reader = Facter::ConfigReader.instance
    end

    def augment!(options)
      options[:block_facts] = Facter::BlockList.instance.block_groups_to_facts
      options[:ttls] = @config_reader.ttls
    end
  end
end