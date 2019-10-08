# frozen_string_literal: true

module Facter
  class CoreFactManager
    def resolve_facts(searched_facts)
      threads = start_threads(searched_facts)
      resolved_facts = join_threads(threads, searched_facts)

      resolved_facts
    end

    private

    def start_threads(searched_facts)
      threads = []

      searched_facts.reject { |elem| elem.fact_class.nil? }.each do |searched_fact|
        threads << Thread.new do
          create_fact(searched_fact)
        end
      end

      threads
    end

    def create_fact(searched_fact)
      fact_class = searched_fact.fact_class
      if searched_fact.name.include?('.*')
        filter_criteria = extract_filter_criteria(searched_fact)

        fact_class.new.call_the_resolver(filter_criteria)
      else
        fact_class.new.call_the_resolver
      end
    end

    Trimmer = Struct.new(:start, :end)
    def extract_filter_criteria(searched_fact)
      name_tokens = searched_fact.name.split('.*')
      trimmer = Trimmer.new(name_tokens[0].length, -(name_tokens[1] || '').length - 1)

      searched_fact.user_query[trimmer.start..trimmer.end]
    end

    def join_threads(threads, searched_facts)
      resolved_facts = []

      threads.each do |thread|
        thread.join
        resolved_facts << thread.value
      end

      resolved_facts.flatten!

      FactAugmenter.augment_resolved_facts(searched_facts, resolved_facts)
    end
  end
end
