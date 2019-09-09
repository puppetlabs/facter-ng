# frozen_string_literal: true

module Facter
  class YamlFactFormatter
    def format(fact_hash)
      YAML.dump(JSON.parse(JsonFactFormatter.new.format(fact_hash)))
    end
  end
end
