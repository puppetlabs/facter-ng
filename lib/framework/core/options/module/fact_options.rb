module Facter
  module FactsOptions
    def augment_with_facts_options!
      config_reader = Facter::ConfigReader.instance

      @options[:block_facts] = Facter::BlockList.instance.block_groups_to_facts
      @options[:ttls] = config_reader.ttls
    end
  end
end
