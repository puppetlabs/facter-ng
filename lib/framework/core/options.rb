# frozen_string_literal: true

module Facter
  class Options
    include Facter::DefaultOptions
    include Facter::ConfigFileOptions
    include Facter::CliOptions
    include Facter::HelperOptions

    include Singleton

    def initialize
      @options = {}
    end

    def refresh(cli_options = {}, user_query = [])
      @cli_options = cli_options
      @user_query = user_query
      initialize_options

      @options
    end

    def get
      @options
    end

    def [](option)
      @options.fetch(option, nil)
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

    # def change_log_level(log_level)
    #  @options[:debug] = log_level
    # end

    attr_reader :persistent_options

    attr_writer :persistent_options

    def self.method_missing(name, *args, &block)
      Facter::Options.instance.send(name.to_s, *args, &block)
    rescue NoMethodError
      super
    end

    def self.respond_to_missing?(name, include_private) end

    private

    def initialize_options
      augment_with_defaults!
      augment_with_to_hash_defaults! if @cli_options[:to_hash]
      augment_with_config_file_options!(@cli_options[:config])
      augment_with_cli_options!(@cli_options)
      @options.merge!(@persistent_options) if @persistent_options
      augment_with_helper_options!(@user_query)
    end
  end
end
