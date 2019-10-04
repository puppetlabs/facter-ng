
module Facter
  class CustomFactLoader
    def initialize
      LegacyFacter.search("#{ROOT_DIR}/custom_facts")
      LegacyFacter.search_external(["#{ROOT_DIR}/external_facts"])

      custom_facts = LegacyFacter.collection.custom_facts

      loaded_custom_facts = {}
      custom_facts.each { |k, v| loaded_custom_facts.merge!({k => 'no_class'}) }

      loaded_custom_facts
    end
  end
end