# frozen_string_literal: true

module Facter
  class CacheList
    include Singleton

    attr_reader :cache_groups, :groups_ttls

    def initialize(block_list_path = nil)
      @block_groups_file_path = block_list_path || File.join(ROOT_DIR, 'fact_groups.conf')
      load_cache_groups
    end

    # Get the group name a fact is part of
    def get_fact_group(fact_name)
      @cache_groups.detect { |k, v| break k if Array(v).include?(fact_name) }
    end

    # Get config ttls for a given group
    def get_group_ttls(group_name)
      return unless (ttls = @groups_ttls.find { |g| g[group_name] })

      ttls[group_name]
    end

    private

    def load_cache_groups
      @cache_groups = Facter::GroupList.instance.groups
      options = Options.instance
      @groups_ttls = ConfigReader.new(options[:config]).ttls || {}
    end
  end
end
