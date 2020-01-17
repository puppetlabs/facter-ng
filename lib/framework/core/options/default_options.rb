# frozen_string_literal: true

module Facter
  module DefaultOptions
    def augment_with_defaults!
      cli_defaults
      global_defaults
    end

    def augment_with_to_hash_defaults!
      cli_to_hash_defaults
    end

    private

    def cli_defaults
      @options[:debug] = false
      @options[:trace] = false
      @options[:verbose] = false
      @options[:log_level] = :warn
      @options[:show_legacy] = false
    end

    def cli_to_hash_defaults
      @options[:show_legacy] = true
    end

    def global_defaults
      @options[:custom_facts] = true
      @options[:custom_dir] = []
      @options[:external_facts] = true
      @options[:external_dir] = []
      @options[:ruby] = true
    end
  end
end
