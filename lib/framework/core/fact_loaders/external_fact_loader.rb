# frozen_string_literal: true

module Facter
  class ExternalFactLoader
    attr_reader :facts

    def initialize
      LegacyFacter.search("#{ROOT_DIR}/custom_facts")
      LegacyFacter.search_external(["#{ROOT_DIR}/external_facts"])

      custom_facts_to_load = LegacyFacter.collection.custom_facts

      @facts = {}
      custom_facts_to_load.each { |k, _v| @facts.merge!(k.to_s => nil) }
    end
  end
end
