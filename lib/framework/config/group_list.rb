# frozen_string_literal: true

module Facter
  class GroupList
    include Singleton

    attr_reader :groups

    def initialize(group_list_path = nil)
      @groups_file_path = group_list_path || File.join(ROOT_DIR, 'fact_groups.conf')
      @groups ||= File.readable?(@groups_file_path) ? Hocon.load(@groups_file_path) : {}
    end
  end
end
