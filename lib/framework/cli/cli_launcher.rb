#!/usr/bin/env ruby
# frozen_string_literal: true

require 'thor'
require "#{ROOT_DIR}/lib/framework/logging/logger.rb"
Facter::Log.output(STDERR)
require "#{ROOT_DIR}/lib/facter"
require "#{ROOT_DIR}/lib/framework/cli/cli"

class CliLauncher
  def initialize(args)
    @args = args
  end

  def validate_options
    Facter::OptionsValidator.validate(@args)
  end

  def prepare_arguments
    @args.unshift(Facter::Cli.default_task) unless
      Facter::Cli.all_tasks.key?(@args[0]) ||
      check_if_arguments_is_known(Facter::Cli.instance_variable_get(:@map), @args)

    @args = reorder_program_arguments(@args)
  end

  def start
    Facter::Cli.start(@args, debug: true)
  rescue Thor::UnknownArgumentError => e
    Facter::OptionsValidator.write_error_and_exit("unrecognised option '#{e.unknown.first}'")
  end

  private

  def check_if_arguments_is_known(known_arguments, program_arguments)
    program_arguments.each do |argument|
      return true if known_arguments.key?(argument)
    end

    false
  end

  def reorder_program_arguments(program_arguments)
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
end

cli_launcher = CliLauncher.new(ARGV)

cli_launcher.validate_options
cli_launcher.prepare_arguments
cli_launcher.start
