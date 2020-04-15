# frozen_string_literal: true

module Facter
  class OsHierarchy
    @searched_path = []

    def initialize
      json_file = Util::FileHelper.safe_read('os_hierarchy.json')
      @json_data = JSON.parse(json_file)
    end

    def construct_hierarchy(searched_os)
      @searched_path = []
      search(@json_data, searched_os, [])

      @searched_path.map { |os_name| os_name.to_s.capitalize }
    end

    private

    def search(json_data, searched_element, path)
      # we hit a dead end, the os was not found on this branch
      # and we cannot go deeper
      return unless json_data

      json_data.each do |tree_node|
        # we found the searched OS, so save the path from the tree
        @searched_path = path.dup << tree_node if tree_node == searched_element

        next unless tree_node.is_a?(Hash)

        tree_node.each do |k, v|
          search(v, searched_element, path << k)
          path.pop
        end
      end
    end
  end
end
