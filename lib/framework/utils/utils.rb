# frozen_string_literal: true

module Facter
  module Utils
    # Sort nested hash.
    def self.sort_hash_by_key(hash, recursive = true, &block)
      hash.keys.sort(&block).each_with_object({}) do |key, seed|
        seed[key] = hash[key]
        seed[key] = sort_hash_by_key(seed[key], true, &block) if recursive && seed[key].is_a?(Hash)

        seed
      end
    end

    def self.deep_copy(obj)
      Marshal.load(Marshal.dump(obj))
    end

    def self.split_user_query(user_query)
      queries = user_query.split('.')
      queries.map! { |query| query =~ /^[0-9]+$/ ? query.to_i : query }
    end

    def self.deep_stringify_keys(hash)
      {}.tap do |h|
        hash.each { |key, value| key.class == Integer ? h[key] = map_value(value) : h[key.to_s] = map_value(value) }
      end
    end

    def self.map_value(collection)
      case collection
      when Hash
        deep_stringify_keys(collection)
      when Array
        collection.map { |value| map_value(value) }
      else
        collection
      end
    end
  end
end
