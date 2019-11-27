# frozen_string_literal: true

module Facter
  module QueryOptions
    def augment_with_query_options!(user_query)
      @options[:user_query] = true if user_query.any?
      @options[:custom_facts] = false if @options[:ruby] == false
    end
  end
end
