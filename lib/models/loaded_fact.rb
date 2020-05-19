# frozen_string_literal: true

module Facter
  class LoadedFact
    attr_reader :name, :klass, :type
    attr_accessor :file

    def initialize(name, klass, type = nil)
      @name = name
      @klass = klass
      @type = type.nil? ? :core : type
    end
  end
end
