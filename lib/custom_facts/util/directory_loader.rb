# frozen_string_literal: true

# A Facter plugin that loads external facts.
#
# Default Unix Directories:
# /opt/puppetlabs/custom_facts/facts.d, /etc/custom_facts/facts.d, /etc/puppetlabs/custom_facts/facts.d
#
# Beginning with Facter 3, only /opt/puppetlabs/custom_facts/facts.d will be a default external fact
# directory in Unix.
#
# Default Windows Direcotires:
# C:\ProgramData\Puppetlabs\custom_facts\facts.d (2008)
# C:\Documents and Settings\All Users\Application Data\Puppetlabs\custom_facts\facts.d (2003)
#
# Can also load from command-line specified directory
#
# Facts can be in the form of JSON, YAML or Text files
# and any executable that returns key=value pairs.

require 'yaml'

module LegacyFacter
  module Util
    class DirectoryLoader
      class NoSuchDirectoryError < RuntimeError
      end

      # This value makes it highly likely that external facts will take
      # precedence over all other facts
      EXTERNAL_FACT_WEIGHT = 10_000

      # Directory for fact loading
      attr_reader :directories

      def initialize(dir = LegacyFacter::Util::Config.external_facts_dirs, weight = EXTERNAL_FACT_WEIGHT)
        @directories = [dir].flatten
        @weight = weight
      end

      # Load facts from files in fact directory using the relevant parser classes to
      # parse them.
      def load(collection)
        weight = @weight

        searched_facts, cached_facts = load_directory_entries(collection)

        load_cached_facts(collection, cached_facts, weight)

        load_searched_facts(collection, searched_facts, weight)
      end

      private

      def load_directory_entries(_collection)
        cm = Facter::CacheManager.new
        sf = []
        entries.each do |file|
          basename = File.basename(file)
          if sf.find { |f| f.name == basename } && cm.group_cached?(basename)
            Facter.log_exception(Exception.new("Caching is enabled for group \"#{basename}\" while "\
              'there are at least two external facts files with the same filename'))
          else
            searched_fact = Facter::SearchedFact.new(basename, nil, [], nil, :file)
            searched_fact.file = file
            sf << searched_fact
          end
        end

        cm.resolve_facts(sf)
      end

      def load_cached_facts(collection, cached_facts, weight)
        cached_facts.each do |cached_fact|
          collection.add(cached_fact.name, value: cached_fact.value, fact_type: :external,
                                           file: cached_fact.file) { has_weight(weight) }
        end
      end

      def load_searched_facts(collection, searched_facts, weight)
        searched_facts.each do |fact|
          parser = LegacyFacter::Util::Parser.parser_for(fact.file)
          next if parser.nil?

          data = parser.results
          if data == false
            LegacyFacter.warn "Could not interpret fact file #{fact.file}"
          elsif (data == {}) || data.nil?
            LegacyFacter.warn "Fact file #{fact.file} was parsed but returned an empty data set"
          else
            data.each do |p, v|
              collection.add(p, value: v, fact_type: :external,
                                file: fact.file) { has_weight(weight) }
            end
          end
        end
      end

      def entries
        dirs = @directories.select { |directory| File.directory?(directory) }.map do |directory|
          Dir.entries(directory).map { |d| directory + '/' + d }
        end
        dirs.flatten.select { |f| should_parse?(f) }
      rescue Errno::ENOENT
        []
      end

      def should_parse?(file)
        File.basename(file) !~ /^\./
      end
    end
  end
end
