# frozen_string_literal: true

require 'pry-byebug'

module Facter
  class Options
    include Singleton

    def set(options)
      @options = options || []
    end

    def get(option)
      @options[option]
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
