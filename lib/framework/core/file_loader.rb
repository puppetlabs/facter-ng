# frozen_string_literal: true

require 'open3'
require 'json'
require 'yaml'

require "#{ROOT_DIR}/lib/framework/logging/multilogger"
require "#{ROOT_DIR}/lib/framework/logging/logger"

require "#{ROOT_DIR}/lib/resolvers/base_resolver"
require "#{ROOT_DIR}/lib/framework/detector/current_os"
require "#{ROOT_DIR}/lib/framework/core/facter"

def load_dir(*dirs)
  Dir.glob(File.join(ROOT_DIR, dirs, '*.rb'), &method(:require))
end

load_dir(['config'])

def load_lib_dirs(*dirs)
  load_dir(['lib', dirs])
end

load_lib_dirs('resolvers')
load_lib_dirs('facts_utils')
load_lib_dirs('utils')
load_lib_dirs('framework', 'core')
load_lib_dirs('models')

os = ENV['RACK_ENV'] == 'test' ? '' : CurrentOs.instance.identifier

load_lib_dirs('facts', os.to_s, '**')
load_lib_dirs('resolvers', os.to_s, '**') if os.to_s =~ /win/

require "#{ROOT_DIR}/lib/framework/helpers/utils"
require "#{ROOT_DIR}/lib/framework/formatters/formatter_factory"
require "#{ROOT_DIR}/lib/framework/formatters/hocon_fact_formatter"
require "#{ROOT_DIR}/lib/framework/formatters/json_fact_formatter"
require "#{ROOT_DIR}/lib/framework/formatters/yaml_fact_formatter"

require "#{ROOT_DIR}/lib/framework/core/fact_augmenter"
require "#{ROOT_DIR}/lib/framework/parsers/query_parser"
