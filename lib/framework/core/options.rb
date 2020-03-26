# frozen_string_literal: true

module Facter
  module Options
    extend self

    extend Facter::DefaultOptions
    extend Facter::ConfigFileOptions
    extend Facter::HelperOptions
    extend Facter::ValidateOptions

    attr_accessor :options
    attr_reader :user_query, :cli

    def cli?
      @cli
    end

    def get
      @options
    end

    def [](key)
      @options.fetch(key, nil)
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

    def user_query=(*value)
      @user_query = value
    end

    # private

    def initialize_options
      @options = {}
      @cli = false
      augment_with_defaults!
      augment_with_to_hash_defaults!
      augment_with_config_file_options!
    end

    def initialize_options_from_cli(cli_options)
      @cli = true
      cli_options.each do |key, val|
        @options[key.to_sym] = val
        @options[key.to_sym] = '' if key == 'log_level' && val == 'log_level'
      end

      # TODO: find a better way than calling this method twice
      augment_with_config_file_options!
      augment_with_helper_options!
    end
  end
end
