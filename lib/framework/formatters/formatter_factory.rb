# frozen_string_literal: true

module Facter
  class FormatterFactory
    def self.build(options)
      return JsonFactFormatter.new if options[:json]
      return YamlFactFormatter.new if options[:yaml]
      return CompatibleFormatter.new if options[:hocon]

      LegacyFactFormatter.new
    end
  end
end
