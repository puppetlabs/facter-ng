# frozen_string_literal: true

module Facter
  class JsonFactFormatter
    def initialize
      @log = Facter::Log.new
    end

    def format(resolved_facts)
      user_queries = resolved_facts.uniq(&:user_query)

      if user_queries.count == 1 && user_queries.first.user_query == ''
        @log.debug('No user query provided')

        fact_colection = FactCollection.new.build_fact_collection!(resolved_facts)
        JSON.pretty_generate(fact_colection)
      else
        @log.debug('User provided a query')

        facts_to_display = {}
        user_queries.each do |user_query|
          facts_for_query = resolved_facts.select { |resolved_fact| resolved_fact.user_query == user_query.user_query }
          fact_colection = FactCollection.new.build_fact_collection!(facts_for_query)

          printable_value = fact_colection.dig(*user_query.user_query.split('.'))
          facts_to_display.merge!(user_query.user_query => printable_value)
        end

        JSON.pretty_generate(facts_to_display)
      end
    end
  end
end
