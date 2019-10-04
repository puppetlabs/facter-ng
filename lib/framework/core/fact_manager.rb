# frozen_string_literal: true

require 'singleton'

module Facter
  class FactManager
    include Singleton

    def initialize
      @os = CurrentOs.instance.identifier
      @core_fact_mgr = CoreFactManager.new
      @custom_fact_mgr = CustomFactManager.new
      @fact_loader = FactLoader.new(@os)
    end

    def resolve_facts(options = {}, user_query = [])
      loaded_facts_hash = user_query.any? || options[:show_legacy] ? load_all_facts : load_core_facts

      searched_facts = Facter::QueryParser.parse(user_query, loaded_facts_hash)

      resolved_facts = resolve_core_facts(searched_facts)
      resolved_facts << resolve_custom_facts(searched_facts)

      resolved_facts.flatten!
      FactFilter.new.filter_facts!(resolved_facts)

      resolved_facts
    end

    def resolve_core(_options = {}, user_query = [])
      loaded_facts_hash = load_core_facts

      searched_facts = Facter::QueryParser.parse(user_query, loaded_facts_hash)
      resolve_core_facts(searched_facts)
    end

    private

    def load_all_facts
      loaded_facts_hash = {}
      loaded_facts_hash.merge!(load_core_facts)
      loaded_facts_hash.merge!(load_legacy_facts)
    end

    def load_core_facts
      # CoreFactLoader.instance.load(@os)
      @fact_loader.core_facts
    end

    def load_legacy_facts
      # LegacyFactLoader.instance.load(@os)
      @fact_loader.legacy_facts
    end

    def resolve_core_facts(searched_facts)
      @core_fact_mgr.resolve_facts(searched_facts.reject { |searched_fact| searched_fact.fact_class.nil? })
    end

    def resolve_custom_facts(searched_facts)
      @custom_fact_mgr.resolve_facts(searched_facts.select { |searched_fact| searched_fact.fact_class.nil? })
    end
  end
end
