# frozen_string_literal: true

module Facter
  class Options

    include Facter::ConfigReaderOptions
    include Facter::HelperOptions
    include Facter::DefaultOptions

    include Singleton
    attr_reader :options

    def set(options = [])
      @options = options.dup
      @conf_reader = Facter::ConfigReader.new(@options[:config])
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
      begin
        Facter::Options.instance.send(name.to_s, *args, &block)
      rescue NoMethodError
        super(name, *args, &block)
      end
    end
  end
end
