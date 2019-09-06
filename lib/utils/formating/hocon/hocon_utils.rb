# frozen_string_literal: true

module Facter
  module HoconUtils
    def change_key_value_delimiter!(pretty_fact_json)
      pretty_fact_json.gsub!(/^(.*?)(:)/, '\1 =>')
    end

    def remove_enclosing_accolades(pretty_fact_json)
      pretty_fact_json[1..-2]
    end

    def remove_quates_from_non_children!(pretty_fact_json)
      pretty_fact_json.gsub!(/\"(.*)\"\ =>/, '\1 =>')
    end

    def remove_empty_lines!(pretty_fact_json)
      pretty_fact_json.gsub!(/^$\n/, '')
    end

    def fix_formatting(pretty_fact_json)
      pretty_fact_json.split("\n").map! { |line| line.gsub(/^  /, '') }
    end
  end
end
