# frozen_string_literal: true

module Facter
  class HoconFactFormatter
    def format(fact_hash)
      if fact_hash.length == 1
        hash_to_hocon_single_value(fact_hash.values[0])
      else
        # fact_hash = sort_by_key(fact_hash, true)
        hash_to_hocon_multiple_values(fact_hash)
      end
    end

    private

    def hash_to_hocon_multiple_values(hash)
      pretty_hocon = hash_to_hocon_single_value(hash)
      pretty_hocon = remove_enclosing_accolades(pretty_hocon)

      fix_formatting(pretty_hocon)
    end

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

    def hash_to_hocon_single_value(hash)
      pretty_json = JSON.pretty_generate(hash)
      change_key_value_delimiter!(pretty_json)
      remove_quates_from_non_children!(pretty_json)
      remove_empty_lines!(pretty_json)

      pretty_json
    end
  end
end
