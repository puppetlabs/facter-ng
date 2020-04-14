

desc 'Create a fact list for the specified os'
task :fact_list_generator, [:os_name] do |_, args|
  ROOT_DIR = Pathname.new(File.expand_path('..', __dir__)) unless defined?(ROOT_DIR)

  require "#{ROOT_DIR}/lib/framework/logging/multilogger"
  require "#{ROOT_DIR}/lib/framework/logging/logger"
  require "#{ROOT_DIR}/lib/framework/detector/os_hierarchy"
  require "#{ROOT_DIR}/lib/framework/detector/os_detector"
  require "#{ROOT_DIR}/lib/framework/core/fact_loaders/class_discoverer"
  require "#{ROOT_DIR}/lib/framework/core/fact_loaders/internal_fact_loader"


  os_hierarchy = Facter::OsHierarchy.new
  hierarchy = os_hierarchy.construct_hierarchy(args[:os_name])

  internal_fact_loader = Facter::InternalFactLoader.new(hierarchy)
  puts internal_fact_loader.facts
end