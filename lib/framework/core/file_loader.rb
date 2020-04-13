# frozen_string_literal: true

require 'open3'
require 'json'
require 'yaml'
require 'hocon'
require 'hocon/config_value_factory'
require 'singleton'
require 'logger'

def load_files(folder, os_name)
  folder_path = File.join(ROOT_DIR, 'lib', folder)
  files_to_load_config_path = File.join(folder_path, os_name,  'files_to_load.rb')
  return unless File.readable?(files_to_load_config_path)

  require files_to_load_config_path

  paths_to_load = Module.const_get("#{folder.capitalize}::#{os_name.capitalize}::Load").files
  paths_to_load.each do |path_to_load|
    path = File.join(folder_path, path_to_load)
    if File.file?(path)
      require path
    else
      load_lib_dirs(folder, path_to_load)
    end
  end
end

def load_dir(*dirs)
  folder_path = File.join(ROOT_DIR, dirs)
  return unless Dir.exist?(folder_path.tr('*', ''))

  files_to_require = Dir.glob(File.join(folder_path, '*.rb')).reject { |file| file =~ %r{/ffi/} }
  files_to_require.each(&method(:require))
end

def load_lib_dirs(*dirs)
  load_dir(['lib', dirs])
end

load_lib_dirs('framework', 'core', 'options')
require "#{ROOT_DIR}/lib/framework/core/options"
require "#{ROOT_DIR}/lib/framework/logging/multilogger"
require "#{ROOT_DIR}/lib/framework/logging/logger"

require "#{ROOT_DIR}/lib/resolvers/base_resolver"
require "#{ROOT_DIR}/lib/framework/detector/os_detector"

require "#{ROOT_DIR}/lib/framework/config/config_reader"
require "#{ROOT_DIR}/lib/framework/config/block_list"
require "#{ROOT_DIR}/lib/resolvers/utils/fingerprint.rb"
require "#{ROOT_DIR}/lib/resolvers/utils/ssh.rb"
require "#{ROOT_DIR}/lib/resolvers/utils/filesystem_helper.rb"

load_dir(['config'])

load_lib_dirs('resolvers')
load_lib_dirs('facts_utils')
load_lib_dirs('framework', 'core')
load_lib_dirs('models')
load_lib_dirs('framework', 'core', 'fact_loaders')
load_lib_dirs('framework', 'core', 'fact', 'internal')
load_lib_dirs('framework', 'core', 'fact', 'external')
load_lib_dirs('framework', 'formatters')

os_hierarchy = OsDetector.instance.hierarchy

os_hierarchy.each { |operating_system| load_files('facts', operating_system.downcase) }
os_hierarchy.each { |operating_system| load_files('resolvers', operating_system.downcase) }

# os_hierarchy.each { |operating_system| load_lib_dirs('facts', operating_system.downcase, '**') }
# os_hierarchy.each { |operating_system| load_lib_dirs('resolvers', operating_system.downcase, '**') }

require "#{ROOT_DIR}/lib/custom_facts/core/legacy_facter"
load_lib_dirs('framework', 'utils')
load_lib_dirs('util')

require "#{ROOT_DIR}/lib/framework/core/fact_augmenter"
require "#{ROOT_DIR}/lib/framework/parsers/query_parser"
