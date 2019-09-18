# frozen_string_literal: true

module Facter
  class SearchedFact
    attr_accessor :name, :fact_class, :filter_tokens, :user_query

    def initialize(fact_name, fact_class, filter_tokens, user_query)
      @name = fact_name
      @fact_class = fact_class
      @filter_tokens = filter_tokens
      @user_query = user_query
    end
  end
end
