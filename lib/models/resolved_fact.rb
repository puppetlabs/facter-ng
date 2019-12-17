# frozen_string_literal: true

module Facter
  class ResolvedFact
    attr_accessor :name, :value, :user_query, :filter_tokens, :type

    def initialize(name, value = '', type = nil)
      @name = name
      @value = value
      @type = type
    end
  end
end
