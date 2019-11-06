# frozen_string_literal: true

module Facter
  class OptionsAugmenter
    include Singleton

    def initialize
      @config_reader = Facter::ConfigReader.instance
    end

    def augment_options(options, user_query)
      options = options.dup

      options_aug = OptionsAug.new(options)

      options_aug.augment_with_cli_options!
      options_aug.augment_with_global_options!
      options_aug.augment_with_facts_options!
      options_aug.augment_with_query_options!(user_query)


      # OptionsQueryAugmenter.new(user_query).augment!(options)
      # OptionsFactAugmenter.new.augment!(options)
      # OptionsCliAugmenter.new.augment!(options)
      # OptionsGlobalAugmenter.new.augment!(options)

      # options = OptionsForQuery.new(options, user_query)
      # options. = OptionsForFacts.new(options)
      # options = OptionsForCli.new(options)
      # options = OptionsForGlobal.new(options)

      # augment_with_query_options!(options, user_query)
      # augment_with_facts_options!(options)
      # augment_with_cli_options!(options)
      # augment_with_global_options!(options)

      options_aug.options
    end

    def augment_with_query_options!(options, user_query)
      options[:user_query] = true if user_query.any?
    end

    def augment_with_facts_options!(options)
      options[:block_facts] = Facter::BlockList.instance.block_groups_to_facts
      options[:ttls] = @config_reader.ttls
    end

    def augment_with_cli_options!(options)
      options[:debug] = @config_reader.cli['debug'] unless options[:debug]
      options[:trace] = @config_reader.cli['trace'] unless options[:trace]
      options[:verbose] = @config_reader.cli['verbose'] unless options[:verbose]
      options[:log_level] = @config_reader.cli['log-level'] unless options[:log_level]
    end

    def augment_with_global_options!(options)
      options[:external_dir] = @config_reader.global['external-dir'] unless options[:external_dir]
      options[:custom_dir] = @config_reader.global['custom-dir'] unless options[:custom_dir]
      options[:custom_dir] = @config_reader.global['custom-dir'] unless options[:custom_dir]
      options[:no_external_facts] = @config_reader.global['no-external-facts'] unless options[:no_external_facts]
    end
  end
end
