#!/usr/bin/env ruby
# frozen_string_literal: true

require 'thor'
require "#{ROOT_DIR}/lib/framework/core/facter"
require "#{ROOT_DIR}/lib/framework/cli/cli"

ARGV.unshift(Facter::Cli.default_task) unless
  Facter::Cli.all_tasks.key?(ARGV[0]) ||
  Facter::Cli.instance_variable_get(:@map).key?(ARGV[0])
Facter::Cli.start(ARGV)
