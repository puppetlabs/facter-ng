# frozen_string_literal: true

module Facter
  class InternalFactLoader
    attr_reader :facts

    def core_facts
      @facts.select { |fact| fact.type == :core }
    end

    def legacy_facts
      @facts.select { |fact| fact.type == :legacy }
    end

    def initialize
      @facts = []

      running_os = OsDetector.instance.identifier
      load_for_os(running_os)
      # os_descendents = OsDetector.instance.hierarchy
      # load_all_oses_in_descending_order(os_descendents)
    end

    private

    def load_all_oses_in_descending_order(os_descendents)
      os_descendents.reverse_each do |os|
        load_for_os(os)
      end
    end

    def load_for_os(operating_system)
      # select only classes
      classes = ClassDiscoverer.instance.discover_classes(operating_system)

      classes.each do |class_name|
        fact_name = class_name::FACT_NAME

        # if fact is already loaded, skip it
        next if @facts.any? { |fact| fact.name == fact_name }

        type = class_name.const_defined?('TYPE') ? class_name::TYPE : :core
        load_fact(fact_name, class_name, type)
        next unless class_name.const_defined?('ALIASES')

        [*class_name::ALIASES].each { |fact_alias| load_fact(fact_alias, class_name, :legacy) }
      end
    end

    def load_fact(fact_name, klass, type)
      loaded_fact = LoadedFact.new(fact_name, klass, type)
      @facts << loaded_fact
    end

    def load_for_os(running_os)
      running_os = running_os.to_s.capitalize
      jsonFile = File.open("#{ROOT_DIR}/os_facts.json")
      @json_data = JSON.load(jsonFile)

      @json_data.each do |os|
        os_name = os['os_name']
        if running_os == os_name
          facts = os['facts']
          facts.each do |fact|
            fact.each do |k, v|
              klass = Module.const_get(v)
              load_fact(k, klass, :core)
            end
          end
        end
      end
    end

  end
end
