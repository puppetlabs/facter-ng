# frozen_string_literal: true

module Facter
  class JsonFactFormatter
    def format(resolved_facts)
      user_queries = resolved_facts.uniq { |elem| elem.user_query }
      if user_queries.count == 1 && user_queries.first.user_query == ''
        # no user query
        puts "all facts"

        fact_colection = FactCollection.new.build_fact_collection!(resolved_facts)
        JSON.pretty_generate(fact_colection)
      else
        puts "one or more user queries"
        # fact_colection = FactCollection.new
        # resolved_facts.each do |resolved_fact|
        #   fact_colection.bury(resolved_fact.user_query)
        # end
        #
        #
        # fact_colection = FactCollection.new.build_fact_collection!(resolved_facts)
        facts_to_display = {}

        resolved_facts.each do |fact|
          # printable_value = fact_colection.dig(*fact.user_query.split('.'))
          facts_to_display.merge!(fact.user_query => fact.value)
        end


        #     printable_value = resolved_facts.dig(*searched_fact.split('.'))
        #     facts_to_display.merge!(searched_fact => printable_value)


        JSON.pretty_generate(facts_to_display)
      end


    end
  end
end
