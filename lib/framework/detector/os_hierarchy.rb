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
      return unless json_data

      json_data.each do |os|
        @searched_path = path.dup << os if os == searched_element

        next unless os.is_a?(Hash)

        os.each do |k, v|
          search(v, searched_element, path << k)
          path.pop
        end
      end
    end
  end
end
