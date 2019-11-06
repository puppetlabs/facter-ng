# frozen_string_literal: true

module Facter
  module FactsOptions
    def augment_with_facts_options!
      @options[:block_facts] = Facter::BlockList.instance.block_groups_to_facts
      @options[:ttls] = @conf_reade.ttls
    end
  end
end
