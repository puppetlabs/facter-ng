# frozen_string_literal: true

module Facter
  class QueryParser
    @log = Log.new

    # Searches for facts that could resolve a user query.
    # There are 3 types of facts:
    #   root facts
    #     e.g. networking
    #   child facts
    #     e.g. networking.dhcp
    #   composite facts
    #     e.g. networking.interfaces.en0.bindings.address
    # Because a root fact will always be resolved by the collection of child facts,
    # we can return one or more child facts.
    #
    # query -  is the user input used to search for facts
    # fact_list - is a list with all facts for the current operating system
    #
    # Returns a list of LoadedFact objects that resolve the users query.
    def self.parse(query_list, loaded_fact_hash)
      matched_facts = []
      @log.debug "User query is: #{query_list}"
      @uq = query_list
      query_list = loaded_fact_hash.keys unless query_list.any?

      query_list.each do |query|
        @log.debug "Query is #{query}"
        matched_facts << search_for_facts(query, loaded_fact_hash)
      end

      matched_facts.flatten(1)
    end

    def self.search_for_facts(query, loaded_fact_hash)
      resolvable_fact_list = []
      query_tokens = query.split('.')
      size = query_tokens.size

      size.times do |i|
        query_token_range = 0..size - i
        resolvable_fact_list = get_facts_matching_tokens(query_tokens, query_token_range, loaded_fact_hash)

        return resolvable_fact_list if resolvable_fact_list.any?
      end

      resolvable_fact_list
    end

    def self.get_facts_matching_tokens(query_tokens, query_token_range, loaded_fact_hash)
      @log.debug "Checking query tokens #{query_tokens[query_token_range].join('.')}"
      resolvable_fact_list = []

      loaded_fact_hash.each do |fact_name, klass_name|
        next if fact_name.match("^#{query_tokens[query_token_range].join('.')}($|\\.)").nil?

        loaded_fact = construct_loaded_fact(query_tokens, query_token_range, fact_name, klass_name)
        resolvable_fact_list << loaded_fact
      end

      @log.debug "List of resolvable facts: #{resolvable_fact_list.inspect}"
      resolvable_fact_list
    end

    def self.construct_loaded_fact(query_tokens, query_token_range, fact_name, klass_name)
      filter_tokens = query_tokens - query_tokens[query_token_range]

      user_query = @uq.any? ? query_tokens[query_token_range].join('.') : ''
      SearchedFact.new(fact_name, klass_name, filter_tokens, user_query)
    end
  end
end
