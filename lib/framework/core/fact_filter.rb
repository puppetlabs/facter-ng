# frozen_string_literal: true

module Facter
  # Filter inside value of a fact.
  # e.g. os.release.major is the user query, os.release is the fact
  # and major is the filter criteria inside tha fact
  class FactFilter
    def filter_facts!(searched_facts)
      searched_facts.each do |fact|
        tokens = fact.filter_tokens.map { |token| token !~ /\D/ && !token.empty? ? token.to_i : token.to_sym }
        value = tokens.any? ? fact.value.dig(*tokens) : fact.value
        fact.value = value
      end
    end
  end
end
