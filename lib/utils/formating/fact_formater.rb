# frozen_string_literal: true

module Facter
  class FactFormater
    # If the user did not provide any query, use the fact collection unchanged.
    # If the user provided some search query,
    # use a hash containing search query as key and query result as value.
    # TODO logic from constructor MUST be removed
    def initialize(resolved_facts)
      # resolved_facts.inspect
      user_queries = resolved_facts.uniq {|elem| elem.user_query}
      if user_queries.count == 1 && user_queries.first.user_query == ''
        # no user query
        puts "all facts"
      end

      if user_queries.count == 1 && user_queries.first.user_query != ''
        # one user query
        puts "one user query"
      end

      if user_queries.count > 1
        # more than one user query
        puts "at least 2 user queries"
      end
      # if searched_facts.length.zero?
      #   @formated_fact_collection = sort_by_key(resolved_facts, true)
      # else
      #   facts_to_display = {}
      #   searched_facts.each do |searched_fact|
      #     printable_value = resolved_facts.dig(*searched_fact.split('.'))
      #     facts_to_display.merge!(searched_fact => printable_value)
      #   end
      #   @formated_fact_collection = sort_by_key(facts_to_display, true)
      # end
    end

    def format_facts(resolved_facts, formatter)
      formatter.format(resolved_facts)
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
