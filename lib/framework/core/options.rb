# frozen_string_literal: true

module Facter
  module Options
    extend Facter::DefaultOptions
    extend Facter::ConfigFileOptions
    extend Facter::HelperOptions
    extend Facter::ValidateOptions

    attr_accessor :options
    attr_reader :config, :user_query

    module_function

    def cli?
      @options[:cli]
    end

    def get
      @options
    end

    def [](key)
      @options.fetch(key, nil)
    end

    def []=(key, value)
      @options[key.to_sym] = value
    end

    def custom_dir?
      @options[:custom_dir] && @options[:custom_facts]
    end

    def custom_dir
      @options[:custom_dir]
    end

    def external_dir?
      @options[:external_dir] && @options[:external_facts]
    end

    def external_dir
      @options[:external_dir]
    end

    def initialize_options
      @options = {}
      @cli = false
      augment_with_defaults!
      augment_with_config_file_options!
    end

    def initialize_options_from_cli(cli_options = {}, user_query = '')
      @cli = true
      # TODO: find a better way than calling this method twice
      augment_with_config_file_options!(cli_options[:config])
      augment_with_helper_options!
      @options[:user_query] = user_query
      cli_options.each do |key, val|
        @options[key.to_sym] = val
        @options[key.to_sym] = '' if key == 'log_level' && val == 'log_level'
      end
    end
  end
end
