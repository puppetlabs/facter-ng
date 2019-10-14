# frozen_string_literal: true

module Facter
  class ExternalFactLoader
    attr_reader :custom_facts, :external_facts, :facts

    def initialize
      LegacyFacter.search("#{ROOT_DIR}/custom_facts")
      LegacyFacter.search_external(["#{ROOT_DIR}/external_facts"])

      custom_facts_to_load = LegacyFacter.collection.custom_facts
      external_facts_to_load = LegacyFacter.collection.external_facts

      @custom_facts = []
      @external_facts = []
      @facts = []

      if custom_facts_to_load
        custom_facts_to_load.each do |k, _v|
          loaded_fact = LoadedFact.new(k.to_s, nil, :custom)
          @custom_facts << loaded_fact
        end
      end

      if external_facts_to_load
        external_facts_to_load.each do |k, _v|
          loaded_fact = LoadedFact.new(k.to_s, nil, :external)
          @external_facts << loaded_fact
        end
      end

      @facts = @custom_facts.concat(@external_facts)
    end
  end
end
