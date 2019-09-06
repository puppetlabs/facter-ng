# frozen_string_literal: true

module Facter
  class YamlFactFormatter
    def format(fact_hash)
      YAML.dump(JSON.parse(fact_hash.to_json))
    end
  end
end
