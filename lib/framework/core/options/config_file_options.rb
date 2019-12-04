# frozen_string_literal: true

module Facter
  module ConfigReaderOptions
    def augment_with_config_file_options!
      augment_cli(@conf_reader.cli)

      global_conf = @conf_reader.global
      return unless global_conf

      augment_custom(global_conf)
      augment_external(global_conf)
      augment_ruby(global_conf)
      augment_facts
    end

    private

    def augment_cli(cli_conf)
      return unless cli_conf

      @options[:debug] = cli_conf['debug'] || @options[:debug]
      @options[:trace] = cli_conf['trace'] || @options[:trace]
      @options[:verbose] = cli_conf['verbose'] || @options[:verbose]
      @options[:log_level] = cli_conf['log-level'] || @options[:log_level]
    end

    def augment_custom(global_conf)
      @options[:custom_facts] = !global_conf['no-custom-facts'] if @options[:custom_facts].nil?
      @options[:custom_dir] = global_conf['custom-dir'] unless @options[:custom_dir]
    end

    def augment_external(global_conf)
      @options[:external_facts] = !global_conf['no-external-facts'] if @options[:external_facts].nil?
      @options[:external_dir] = global_conf['external-dir'] || @options[:external_dir]
    end

    def augment_ruby(global_conf)
      @options[:ruby] = !global_conf['no-ruby'] if @options[:ruby].nil?
    end

    def augment_facts
      @options[:blocked_facts] = Facter::BlockList.instance.blocked_facts
      @options[:ttls] = @conf_reader.ttls
    end
  end
end
