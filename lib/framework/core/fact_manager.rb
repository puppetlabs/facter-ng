# frozen_string_literal: true

require 'singleton'
require 'pry-byebug'
module Facter
  class FactManager
    include Singleton

    def initialize
      @internal_fact_mgr = InternalFactManager.new
      @external_fact_mgr = ExternalFactManager.new
      @fact_loader = FactLoader.instance
    end

    def resolve_facts(options = {}, user_query = [])
      enhance_options(options, user_query)
      loaded_facts = @fact_loader.load(Options)
      searched_facts = QueryParser.parse(user_query, loaded_facts)
      internal_facts = @internal_fact_mgr.resolve_facts(searched_facts)
      external_facts = @external_fact_mgr.resolve_facts(searched_facts)

      resolved_facts = override_core_facts(internal_facts, external_facts)
      FactFilter.new.filter_facts!(resolved_facts)

      resolved_facts
    end

    def resolve_core(user_query = [])
      enhance_options(options, user_query)

      loaded_facts_hash = @fact_loader.internal_facts

      searched_facts = QueryParser.parse(user_query, loaded_facts_hash)
      resolved_facts = @internal_fact_mgr.resolve_facts(searched_facts)
      FactFilter.new.filter_facts!(resolved_facts)

      resolved_facts
    end

    private

    def enhance_options(options, user_query)
      Options.set(options)
      Options.augment_with_defaults!
      Options.augment_with_config_file_options!
      Options.augment_with_query_options!(user_query)
    end

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
