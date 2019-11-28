# frozen_string_literal: true

require 'hocon/config_value_factory'

module Facter
  class HoconFactFormatter
    def initialize
      @log = Log.new
    end

    def format(resolved_facts)
      user_queries = resolved_facts.uniq(&:user_query).map(&:user_query)

      return if user_queries.count < 1
      return format_for_multiple_user_queries(user_queries, resolved_facts) if user_queries.count > 1

      user_query = user_queries.first
      return format_for_no_query(resolved_facts) if user_query.empty?
      return format_for_single_user_query(user_queries.first, resolved_facts) unless user_query.empty?
    end

    private

    def format_for_no_query(resolved_facts)
      @log.debug('Formatting for no user query')
      fact_collection = FactCollection.new.build_fact_collection!(resolved_facts)
      fact_collection = Facter::Utils.sort_hash_by_key(fact_collection)
      hash_to_hocon(fact_collection)
    end

    def format_for_multiple_user_queries(user_queries, resolved_facts)
      @log.debug('Formatting for multiple user queries')
      facts_to_display = {}
      user_queries.each do |user_query|
        fact_collection = build_fact_collection_for_user_query(user_query, resolved_facts)
        printable_value = fact_collection.dig(*user_query.split('.'))
        facts_to_display.merge!(user_query => printable_value)
      end

      facts_to_display = Facter::Utils.sort_hash_by_key(facts_to_display)
      hash_to_hocon(facts_to_display)
    end

    def format_for_single_user_query(user_query, resolved_facts)
      @log.debug('Formatting for single user query')

      fact_collection = build_fact_collection_for_user_query(user_query, resolved_facts)
      fact_collection = Facter::Utils.sort_hash_by_key(fact_collection)
      fact_value = fact_collection.dig(*user_query.split('.'))

      return '' unless fact_value

      fact_value.class == Hash ? hash_to_hocon(fact_value) : fact_value
    end

    def hash_to_hocon(fact_collection)
      render_opts = Hocon::ConfigRenderOptions.new(false, false, true, false)
      Hocon::ConfigFactory.parse_string(fact_collection.to_json).root.render(render_opts)
    end

    def build_fact_collection_for_user_query(user_query, resolved_facts)
      facts_for_query = resolved_facts.select { |resolved_fact| resolved_fact.user_query == user_query }
      FactCollection.new.build_fact_collection!(facts_for_query)
    end
  end
end
