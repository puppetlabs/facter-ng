# frozen_string_literal: true

module Facter
  class FactForm
    # If the user did not provide any query, use the fact collection unchanged.
    # If the user provided some search query,
    # use a hash containing search query as key and query result as value.
    def initialize(searched_facts, fact_collection)
      if searched_facts.length.zero?
        @formated_fact_collection = sort_by_key(fact_collection, true)
      else
        facts_to_display = {}
        searched_facts.each do |searched_fact|
          printable_value = fact_collection.dig(*searched_fact.split('.'))
          facts_to_display.merge!(searched_fact => printable_value)
        end
        @formated_fact_collection = sort_by_key(facts_to_display, true)
      end
    end

    def format_facts(formatter)
      formatter.format(@formated_fact_collection)
    end

    private

    # Sort nested hash.
    def sort_by_key(hash, recursive = false, &block)
      hash.keys.sort(&block).each_with_object({}) do |key, seed|
        seed[key] = hash[key]
        seed[key] = sort_by_key(seed[key], true, &block) if recursive && seed[key].is_a?(Hash)

        seed
      end
    end
  end
end
