# frozen_string_literal: true

module Facter
  class ClassDiscoverer
    include Singleton

    def initialize
      @log = Log.new(self)
    end

    def discover_classes(operating_system)
      os_module_name = Module.const_get("Facts::#{operating_system}")

      # select only classes
      find_nested_classes(os_module_name, discovered_classes = [])
      discovered_classes
    rescue NameError
      @log.error("There is no module named #{operating_system}")
      []
    end

    def find_nested_classes(mod, discovered_classes)
      mod.constants.each do |constant_name|
        if mod.const_get(constant_name).instance_of? Class
          discovered_classes << mod.const_get(constant_name)
        elsif mod.const_get(constant_name).instance_of? Module
          find_nested_classes(Module.const_get("#{mod.name}::#{constant_name}"), discovered_classes)
        end
      end
    end

    def discover_classes_from_file(operating_system)
      discovered_classes = []

      classes_to_load_config = Module.const_get("Facts::#{operating_system}::Load")
      module_names_to_load = classes_to_load_config.modules

      module_names_to_load.each do |module_name|
        module_to_search = Module.const_get(module_name)
        find_nested_classes_2(module_to_search, discovered_classes)
      end
      discovered_classes
    rescue NameError
      @log.error("There is no module named #{operating_system}")
      []
    end

    def find_nested_classes_2(module_to_search, discovered_classes)
      if module_to_search.instance_of? Class
        discovered_classes << module_to_search unless module_to_search.name.include?('Load')
      elsif module_to_search.instance_of? Module
        module_to_search.constants.each do |constant_name|
          constant = module_to_search.const_get(constant_name)
          if (constant.instance_of? Module) || (constant.instance_of? Class)
            find_nested_classes_2(constant, discovered_classes)
          end
        end
      end
    end
  end

end
