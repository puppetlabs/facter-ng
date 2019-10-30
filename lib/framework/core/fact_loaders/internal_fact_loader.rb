# frozen_string_literal: true

module Facter
  class InternalFactLoader
    def core_facts
      @core_facts.values
    end

    def legacy_facts
      @legacy_facts.values
    end

    def facts
      @facts.values
    end

    def initialize
      @core_facts = {}
      @legacy_facts = {}
      @facts = {}

      os_descendents = CurrentOs.instance.hierarchy
      load_all_oses(os_descendents)
    end

    private

    def load_all_oses(os_descendents)
      os_descendents.each do |os|
        load_for_os(os)
      end

      all_facts
    end

    def load_for_os(operating_system)
      # select only classes
      classes = ClassDiscoverer.instance.discover_classes(operating_system)

      classes.each do |class_name|
        klass = klass(operating_system, class_name)
        fact_name = klass::FACT_NAME

        if legacy_fact?(klass)
          load_legacy_fact(fact_name, klass)
        else
          load_core_facts(fact_name, klass)
        end
      end
    end

    def all_facts
      @facts = @legacy_facts.merge(@core_facts)
    end

    def klass(operating_system, class_name)
      Class.const_get("Facter::#{operating_system}::" + class_name.to_s)
    end

    def load_core_facts(fact_name, klass)
      loaded_fact = LoadedFact.new(fact_name, klass, :core)
      @core_facts[fact_name] = loaded_fact
    end

    def load_legacy_fact(fact_name, klass)
      loaded_fact = LoadedFact.new(fact_name, klass, :legacy)
      @legacy_facts[fact_name] = loaded_fact
    end

    def legacy_fact?(klass)
      klass.const_defined?('FACT_TYPE') && klass::FACT_TYPE.equal?(:legacy)
    end
  end
end
