# frozen_string_literal: true

module Facter
  class HoconFactFormatter
    def initialize
      @log = Log.new
    end

    def format(resolved_facts)
      user_queries = resolved_facts.uniq(&:user_query)

      return format_for_no_query(resolved_facts) if user_queries.count == 1 && user_queries.first.user_query == ''

      return format_for_single_user_queries(user_queries, resolved_facts) if user_queries.count == 1 &&
                                                                             user_queries.first.user_query != ''

      return format_for_multiple_user_queries(user_queries, resolved_facts) if user_queries.count > 1
    end

    private

    def format_for_no_query(resolved_facts)
      @log.debug('Formatting for no user query')
      fact_collection = FactCollection.new.build_fact_collection!(resolved_facts)
      pretty_json = hash_to_hocon(fact_collection)
      pretty_json = remove_enclosing_accolades(pretty_json)

      fix_formatting(pretty_json)
    end

    def format_for_multiple_user_queries(user_queries, resolved_facts)
      @log.debug('Formatting for multiple user queries')
      facts_to_display = {}
      user_queries.each do |user_query|
        fact_collection = build_fact_collection_for_user_query(user_query, resolved_facts)
        printable_value = fact_collection.dig(*user_query.user_query.split('.'))
        facts_to_display.merge!(user_query.user_query => printable_value)
      end

      pretty_json = hash_to_hocon(facts_to_display)
      pretty_json = remove_enclosing_accolades(pretty_json)

      fix_formatting(pretty_json)
    end

    def format_for_single_user_queries(user_queries, resolved_facts)
      @log.debug('Formatting for single user query')
      printable_value = nil
      user_queries.each do |user_query|
        fact_collection = build_fact_collection_for_user_query(user_query, resolved_facts)
        printable_value = fact_collection.dig(*user_query.user_query.split('.'))
      end

      hash_to_hocon(printable_value)
    end

    def hash_to_hocon(facts_hash)
      @log.debug('Converting hash to pretty json')
      pretty_json = JSON.pretty_generate(facts_hash)

      @log.debug('Change key value delimiter from : to =>')
      pretty_json.gsub!(/^(.*?)(:)/, '\1 =>')

      @log.debug('Remove quates form parent nodes')
      pretty_json.gsub!(/\"(.*)\"\ =>/, '\1 =>')

      pretty_json
    end

    def remove_enclosing_accolades(pretty_fact_json)
      @log.debug('Removing enclosing accolades')
      pretty_fact_json[1..-2]

      @log.debug('Remove empty lines')
      pretty_fact_json.gsub!(/^$\n/, '')

      @log.debug('Fix indentation after removing enclosed accolades')
      pretty_fact_json.split("\n").map! { |line| line.gsub(/^  /, '') }
    end

    def build_fact_collection_for_user_query(user_query, resolved_facts)
      facts_for_query = resolved_facts.select { |resolved_fact| resolved_fact.user_query == user_query.user_query }
      FactCollection.new.build_fact_collection!(facts_for_query)
    end
  end
end
