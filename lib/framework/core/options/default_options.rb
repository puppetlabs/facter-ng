# frozen_string_literal: true

module Facter
  module DefaultOptions
    def augment_with_defaults!
      cli_defaults
      global_defaults
    end

    DEFAULT_LOG_LEVEL = :warn

    private

    def cli_defaults
      @options[:debug] = false
      @options[:trace] = false
      @options[:verbose] = false
      @options[:log_level] = DEFAULT_LOG_LEVEL
      @options[:show_legacy] = false
    end

    def global_defaults
      @options[:block] = true
      @options[:custom_dir] = []
      @options[:external_dir] = []
      @options[:ruby] = true
    end
  end
end
