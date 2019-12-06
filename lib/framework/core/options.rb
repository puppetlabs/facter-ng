# frozen_string_literal: true

module Facter
  class Options
    include Facter::DefaultOptions
    include Facter::ConfigReaderOptions
    include Facter::HelperOptions
    include Facter::CliOptions

    include Singleton
    attr_reader :options

    def initialize
      @options = {}
    end

    def [](option)
      @options.fetch(option, nil)
    end

    def custom_dir
      @options[:custom_dir]
    end

    def custom_dir?
      @options[:custom_dir] && @options[:custom_facts]
    end

    def external_dir
      @options[:external_dir]
    end

    def external_dir?
      @options[:external_dir] && @options[:external_facts]
    end

    def self.method_missing(name, *args, &block)
      Facter::Options.instance.send(name.to_s, *args, &block)
    rescue NoMethodError
      super
    end

    def self.respond_to_missing?(name, include_private) end
  end
end
