# frozen_string_literal: true

module Facter
  class FactFormater
    def format_facts(resolved_facts, formatter)
      formatter.format(resolved_facts)
    end

    private

    # Sort nested hash.
    def sort_by_key(hash, recursive = false, &block)
      hash.keys.sort(&block).each_with_object({}) do |key, seed|
        seed[key] = hash[key]
        seed[key] = sort_by_key(seed[key], true, &block) if recursive && seed[key].is_a?(Hash)

        seed
      end
    end
  end
end
