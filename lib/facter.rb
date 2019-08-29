# frozen_string_literal: true

require 'pathname'

ROOT_DIR = Pathname.new(File.expand_path('..', __dir__)) unless defined?(ROOT_DIR)
require "#{ROOT_DIR}/lib/utils/file_loader"

module Facter
  def self.to_hash
    Facter::Base.new([])
  end

  def self.value(*args)
    Facter::Base.new(args)
  end

  class Base
    def initialize(user_query)
      os = OsDetector.detect_family
      loaded_facts_hash = Facter::FactLoader.load(os)
      searched_facts = Facter::QueryParser.parse(user_query, loaded_facts_hash)
      resolve_matched_facts(user_query, searched_facts)
    end

    private

    def resolve_matched_facts(user_query, searched_facts)
      threads = start_threads(searched_facts)
      join_threads!(threads, searched_facts)

      FactFilter.new.filter_facts!(searched_facts)
      fact_collection = FactCollection.new.build_fact_collection!(searched_facts)

      FactFormatter.new(user_query, fact_collection)
    end

    def start_threads(searched_facts)
      threads = []

      searched_facts.each do |searched_fact|
        threads << Thread.new do
          fact_class = searched_fact.fact_class
          fact_class.new.call_the_resolver
        end
      end

      threads
    end

    def join_threads!(threads, searched_facts)
      threads.each do |thread|
        thread.join
        fact = thread.value
        enrich_searched_fact_with_value!(searched_facts, fact)
      end

      searched_facts
    end

    def enrich_searched_fact_with_value!(searched_facts, fact)
      matched_fact = searched_facts.select { |elem| elem.name == fact.name }
      matched_fact.first.value = fact.value
    end
  end
end
