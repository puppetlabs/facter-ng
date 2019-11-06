module Facter
  module GlobalOptions
    def augment_with_global_options!
      @config_reader = Facter::ConfigReader.instance

      @options[:external_dir] = @config_reader.global['external-dir'] unless @options[:external_dir]
      @options[:custom_dir] = @config_reader.global['custom-dir'] unless @options[:custom_dir]
      @options[:custom_dir] = @config_reader.global['custom-dir'] unless @options[:custom_dir]
      @options[:no_external_facts] = @config_reader.global['no-external-facts'] unless @options[:no_external_facts]
    end
  end
end
