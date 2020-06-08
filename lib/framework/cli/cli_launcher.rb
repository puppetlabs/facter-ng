#!/usr/bin/env ruby
# frozen_string_literal: true

require 'thor'
require "#{ROOT_DIR}/lib/framework/logging/logger.rb"
Facter::Log.output(STDERR)
require "#{ROOT_DIR}/lib/facter"
require "#{ROOT_DIR}/lib/framework/cli/cli"

def check(known_arguments, program_arguments)
  program_arguments.each do |argument|
    return true if known_arguments.key?(argument)
  end

  false
end

def reorder!(program_arguments)
  priority_arguments = Facter::Cli.instance_variable_get(:@map)

  priority_args = []
  normal_args = []

  program_arguments.each do |argument|
    if priority_arguments.include?(argument)
      priority_args << argument
    else
      normal_args << argument
    end
  end

  priority_args.concat(normal_args)
end

Facter::OptionsValidator.validate(ARGV)
ARGV.unshift(Facter::Cli.default_task) unless
  Facter::Cli.all_tasks.key?(ARGV[0]) ||
  check(Facter::Cli.instance_variable_get(:@map), ARGV)

ARGV = reorder!(ARGV)

begin
  Facter::Cli.start(ARGV, debug: true)
rescue Thor::UnknownArgumentError => e
  Facter::OptionsValidator.write_error_and_exit("unrecognised option '#{e.unknown.first}'")
end
