module Facter
  class OptionsAugmenter

    def self.augment_options(options, user_query)
      options = options.dup
      options[:user_query] = true if user_query.any?
      options[:block_facts] = Facter::BlockList.instance.block_groups_to_facts

      config_reader = Facter::ConfigReader.instance
      options[:ttls] = config_reader.ttls

      # set if they are not given as global commands
      options[:external_dir] = config_reader.global['external-dir'] unless options[:external_dir]
      options[:custom_dir] = config_reader.global['custom-dir'] unless options[:custom_dir]
      options[:custom_dir] = config_reader.global['custom-dir'] unless options[:custom_dir]
      options[:no_external_facts] = config_reader.global['no-external-facts'] unless options[:no_external_facts]


      # set if they are not given as cli commands
      options[:debug] = config_reader.cli['debug'] unless options[:debug]
      options[:trace] = config_reader.cli['trace'] unless options[:trace]
      options[:verbose] = config_reader.cli['verbose'] unless options[:verbose]
      options[:log_level] = config_reader.cli['log-level'] unless options[:log_level]

      options
    end
  end
end