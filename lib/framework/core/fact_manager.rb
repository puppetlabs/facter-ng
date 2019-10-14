# frozen_string_literal: true

require 'singleton'

module Facter
  class FactManager
    include Singleton

    def initialize
      @core_fact_mgr = CoreFactManager.new
      @custom_fact_mgr = CustomFactManager.new
      # @internal_loader = InternalFactLoader.new
      # @external_fact_loader = ExternalFactLoader.new

    end

    def resolve_facts(options = {}, user_query = [])
      options = options.dup
      options[:user_query] = true if user_query.any?

      fact_loader = FactLoader.instance
      loaded_facts_hash = fact_loader.load(options)
      searched_facts = QueryParser.parse(user_query, loaded_facts_hash)

      core_facts = resolve_core_facts(searched_facts)
      custom_facts = resolve_custom_facts(searched_facts)

      resolved_facts = override_core_facts(core_facts, custom_facts)
      FactFilter.new.filter_facts!(resolved_facts)

      resolved_facts
    end

    def resolve_core(options = {}, user_query = [])
      options[:user_query] = true if user_query.any?

      fact_loader = FactLoader.instance
      fact_loader.load(options)
      loaded_facts_hash = fact_loader.internal_facts

      searched_facts = QueryParser.parse(user_query, loaded_facts_hash)
      resolved_facts = resolve_core_facts(searched_facts)
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

    def resolve_core_facts(searched_facts)
      @core_fact_mgr.resolve_facts(
        searched_facts.select { |searched_fact| searched_fact.type == :core || searched_fact.type == :legacy})
    end

    def resolve_custom_facts(searched_facts)
      searched_custom_facts =
        searched_facts.select { |searched_fact| searched_fact.type == :custom ||  searched_fact.type == :external}

      @custom_fact_mgr.resolve_facts(searched_custom_facts)
    end
  end
end
