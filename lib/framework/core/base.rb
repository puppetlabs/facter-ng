
module Facter
  class Base
    def resolve_facts(options = {}, user_query = [])
      loaded_facts_hash = load_core_facts(options, user_query)

      searched_facts = Facter::QueryParser.parse(user_query, loaded_facts_hash)
      resolve_matched_facts(searched_facts)
    end

    def resolve_core(options = {}, user_query = [])
      loaded_facts_hash = load_core_facts(options, user_query)

      searched_facts = Facter::QueryParser.parse(user_query, loaded_facts_hash)
      resolve_core_facts(searched_facts)
    end

    private

    def load_core_facts(options, user_query)
      os = CurrentOs.instance.identifier
      loaded_facts_hash = if user_query.any? || options[:show_legacy]
                            Facter::FactLoader.load_with_legacy(os)
                          else
                            Facter::FactLoader.load(os)
                          end
      loaded_facts_hash
    end


    def resolve_core_facts(searched_facts)
      core_fact_mgr = CoreFactManager.new
      core_fact_mgr.resolve_facts(searched_facts.select{|searched_Fact| !searched_Fact.fact_class.nil?})
    end

    def resolve_custom_facts(searched_facts)
      custom_fact_mgr = CustomFactManager.new
      custom_fact_mgr.resolve_facts(searched_facts.select {|searched_fact| searched_fact.fact_class.nil? })
    end

    def resolve_matched_facts(searched_facts)
      core_fact_mgr = CoreFactManager.new
      custom_fact_mgr = CustomFactManager.new

      resolved_facts = core_fact_mgr.resolve_facts(searched_facts.select{|searched_Fact| !searched_Fact.fact_class.nil?})
      resolved_facts << custom_fact_mgr.resolve_facts(searched_facts.select {|searched_fact| searched_fact.fact_class.nil? })
      resolved_facts.flatten!
      FactFilter.new.filter_facts!(resolved_facts)

      resolved_facts
    end
  end
end