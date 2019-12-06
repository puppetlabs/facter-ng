# frozen_string_literal: true

module Facter
  module ConfigReaderOptions
    def augment_with_config_file_options!
      conf_reader = Facter::ConfigReader.new(@options[:config])
      global_conf = conf_reader.global

      augment_cli(conf_reader.cli)
      augment_custom(global_conf)
      augment_external(global_conf)
      augment_ruby(global_conf)
      augment_facts(global_conf)
    end

    private

    def augment_cli(file_cli_conf)
      return unless file_cli_conf

      @options[:debug] = file_cli_conf['debug'] || @options[:debug]
      @options[:trace] = file_cli_conf['trace'] || @options[:trace]
      @options[:verbose] = file_cli_conf['verbose'] || @options[:verbose]
      @options[:log_level] = file_cli_conf['log-level'] || @options[:log_level]
    end

    def augment_custom(file_global_conf)
      return unless file_global_conf

      @options[:custom_facts] = !file_global_conf['no-custom-facts'] || @options[:custom_facts]
      @options[:custom_dir] = file_global_conf['custom-dir'] || @options[:custom_dir]
    end

    def augment_external(global_conf)
      return unless global_conf

      @options[:external_facts] = !global_conf['no-external-facts'] || @options[:external_facts]
      @options[:external_dir] = global_conf['external-dir'] || @options[:external_dir]
    end

    def augment_ruby(global_conf)
      return unless global_conf

      @options[:ruby] = !global_conf['no-ruby'] || @options[:ruby]
    end

    def augment_facts(global_conf)
      @options[:blocked_facts] = Facter::BlockList.instance.blocked_facts || @options[:blocked_facts]

      return unless global_conf

      @options[:ttls] = global_conf.ttls || @options[:ttls]
    end
  end
end
