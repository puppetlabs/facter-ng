# frozen_string_literal: true

module Facter
  class ResolvedFact
    attr_reader :name, :type
    attr_accessor :user_query, :filter_tokens, :value

    def initialize(name, value = '', type = :core)
      @name = name
      @value = Utils.deep_stringify_keys(value)

      @type = type if type =~ /core|legacy|custom/
      raise ArgumentError, 'The type provided for fact is not legacy or core!' unless type =~ /core|legacy|custom/
    end

    def legacy?
      type == :legacy
    end

    def core?
      type == :core
    end
  end
end
