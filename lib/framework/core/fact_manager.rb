# frozen_string_literal: true

require 'singleton'

module Facter
  class FactManager
    include Singleton

    def initialize
      @core_fact_mgr = CoreFactManager.new
      @custom_fact_mgr = CustomFactManager.new
      @fact_loader = FactLoader.instance
    end

    def resolve_facts(options = {}, user_query = [])
      options = options.dup
      options[:user_query] = true if user_query.any?

      loaded_facts_hash = @fact_loader.load(options)
      searched_facts = QueryParser.parse(user_query, loaded_facts_hash)
      core_facts = @core_fact_mgr.resolve_facts(searched_facts)
      custom_facts = @custom_fact_mgr.resolve_facts(searched_facts)

      resolved_facts = override_core_facts(core_facts, custom_facts)
      FactFilter.new.filter_facts!(resolved_facts)

      resolved_facts
    end

    def resolve_core(options = {}, user_query = [])
      options[:user_query] = true if user_query.any?

      @fact_loader.load(options)
      loaded_facts_hash = fact_loader.internal_facts

      searched_facts = QueryParser.parse(user_query, loaded_facts_hash)
      resolved_facts = @core_fact_mgr.resolve_facts(searched_facts)
      FactFilter.new.filter_facts!(resolved_facts)

      resolved_facts
    end

    private

    def override_core_facts(core_facts, custom_facts)
      return core_facts unless custom_facts

      custom_facts.each do |custom_fact|
        core_facts.delete_if { |core_fact| root_fact_name(core_fact) == custom_fact.name }
      end

      core_facts + custom_facts
    end

    def root_fact_name(fact)
      fact.name.split('.').first
    end
  end
end
