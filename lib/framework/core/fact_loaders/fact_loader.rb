
module Facter
  class FactLoader
    attr_reader :core_facts, :legacy_facts, :all_facts

    def initialize(operating_system)
      @core_facts = {}
      @legacy_facts = {}
      @all_facts = {}

      load(operating_system)
    end

    def refresh(operating_system)
      @core_facts = {}
      @legacy_facts = {}
      @all_facts = {}

      load(operating_system)
    end

    private

    def load(operating_system)
      loaded_facts = {}
      os = operating_system.capitalize

      # select only classes
      classes = ClassDiscoverer.instance.discover_classes(os)

      classes.each do |class_name|
        klass = Class.const_get("Facter::#{os}::" + class_name.to_s)
        fact_name = klass::FACT_NAME

        if legacy_fact?(klass)
          @legacy_facts.merge!(fact_name => klass)
        else
          @core_facts.merge!(fact_name => klass)
        end
      end

      loaded_facts
    end

    def legacy_fact?(klass)
      klass.const_defined?('FACT_TYPE') && klass::FACT_TYPE.equal?(:legacy)
    end
  end
end