# frozen_string_literal: true

module Facter
  class YamlFactFormatter
    def initialize
      @log = Log.new(self)
    end

    def format(fact_hash)
      yaml_pretty = YAML.dump(JSON.parse(JsonFactFormatter.new.format(fact_hash)))

      @log.debug('Replace single backslash with double backslashes')
      yaml_pretty.gsub!(/\\/, '\&\&')
      @log.debug('Replace ---  from yaml beginning, to keep it compatible with C facter')
      yaml_pretty.gsub(/^---[\r\n]+/, '')
    end
  end
end
