# frozen_string_literal: true

require_relative 'config_reader'

module Facter
  class BlockList
    include Singleton

    attr_reader :block_groups

    def initialize(block_list_path = nil)
      @block_groups_file_path = block_list_path || 'block_groups.conf'
    end

    def block_groups_to_facts
      fact_list = []
      load_block_groups

      @block_list.each do |group_name|
        facts_for_block = @block_groups[group_name]

        fact_list += facts_for_block || [group_name]
      end

      fact_list
    end

    private

    def load_block_groups
      @block_groups = Hocon.load(@block_groups_file_path)
      @block_list = ConfigReader.new.block_list
    end
  end
end
