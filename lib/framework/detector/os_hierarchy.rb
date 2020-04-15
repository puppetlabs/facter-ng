
module Facter
  class OsHierarchy
    @searched_path = []

    def initialize
      jsonFile = Util::FileHelper.safe_read("os_hierarchy.json")
      @jsonData = JSON.load(jsonFile)
    end

    def construct_hierarchy(searched_os)
      @searched_path = []
      search(@jsonData, searched_os, [])

      @searched_path.map {|os_name| os_name.to_s.capitalize}
    end

    private

    def search(jsonData, searched_element , path)
      return unless jsonData

      jsonData.each do |os|
        if os == searched_element
          @searched_path = path.dup << os
        end

        if os.is_a?(Hash)
          os.each do |k, v|
            search(v, searched_element, path << k)
            path.pop
          end
        end
      end
    end
  end
end
