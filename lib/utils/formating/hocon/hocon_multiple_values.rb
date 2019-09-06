# frozen_string_literal: true

module Facter
  class HoconMultipleValues
    include HoconUtils

    def initialize(fact_hash)
      @fact_hash = fact_hash
    end

    def to_hocon
      pretty_json = JSON.pretty_generate(@fact_hash)
      change_key_value_delimiter!(pretty_json)
      remove_quates_from_non_children!(pretty_json)
      remove_empty_lines!(pretty_json)
      pretty_json = remove_enclosing_accolades(pretty_json)

      fix_formatting(pretty_json)
    end
  end
end
