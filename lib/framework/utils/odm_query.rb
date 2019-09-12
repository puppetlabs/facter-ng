# frozen_string_literal: true

module Facter
  class ODMQuery
    attr_reader :query
    REPOS = %w[CuDv CuAt PdAt PdDv].freeze

    def initialize
      @query = ''
      @conditions = []
    end

    def equals(field, value)
      @conditions << "'#{field}' = '#{value}'"
      self
    end

    def like(field, value)
      @conditions << "'#{field}' like '#{value}'"
      self
    end

    def execute
      result = ''
      REPOS.each do |repo|
        break unless result

        result, _s = Open3.capture2("#{query} #{repo}")
      end
      result
    end

    def query
      "odmget -q " + @conditions.join(' AND ')
    end
  end
end
