# frozen_string_literal: true

module Facter
  class LegacyFactLoader
    include Singleton

    def load(operating_system)
      loaded_facts = {}
      os = operating_system.capitalize

      # select only classes
      classes = ClassDiscoverer.instance.discover_classes(os)

      classes.each do |class_name|
        klass = Class.const_get("Facter::#{os}::" + class_name.to_s)

        next unless legacy_fact?(klass)

        fact_name = klass::FACT_NAME
        loaded_facts.merge!(fact_name => klass)
      end

      loaded_facts
    end

    def legacy_fact?(klass)
      klass.const_defined?('FACT_TYPE') && klass::FACT_TYPE.equal?(:legacy)
    end
  end
end
