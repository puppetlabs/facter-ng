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
        @directories = dir
        @weight = weight
      end

      # def self.loader_for(dir)
      #   raise NoSuchDirectoryError unless File.directory?(dir)
      #
      #   LegacyFacter::Util::DirectoryLoader.new(dir)
      # end

      # def self.default_loader
      #   loaders = LegacyFacter::Util::Config.external_facts_dirs.collect do |dir|
      #     LegacyFacter::Util::DirectoryLoader.new(dir)
      #   end
      #   LegacyFacter::Util::CompositeLoader.new(loaders)
      # end

      # Load facts from files in fact directory using the relevant parser classes to
      # parse them.
      def load(collection)
        weight = @weight
        cm = Facter::CacheManager.new
        sf = []
        entries.each do |file|
          basename = File.basename(file)
          if sf.find { |f| f.name == basename } && cm.group_cached?(basename)
            Facter.log_exception(Exception.new("Caching is enabled for group \"#{basename}\" while there are at least two external facts files with the same filename"))
          else
            f = Facter::SearchedFact.new(basename, nil, [], nil, :file)
            f.file = file
            sf << f
          end
        end
        searched_facts, cached_facts = cm.resolve_facts(sf)

        cached_facts.each do |cached_fact|
          collection.add(cached_fact.name, value: cached_fact.value, fact_type: :external, file: cached_fact.file) { has_weight(weight) }
        end

        searched_facts.each do |fact|
          parser = LegacyFacter::Util::Parser.parser_for(fact.file)
          next if parser.nil?

          data = parser.results
          if data == false
            LegacyFacter.warn "Could not interpret fact file #{fact.file}"
          elsif (data == {}) || data.nil?
            LegacyFacter.warn "Fact file #{fact.file} was parsed but returned an empty data set"
          else
            data.each { |p, v| collection.add(p, value: v, fact_type: :external, file: fact.file) { has_weight(weight) } }
          end
        end
      end

      private

      def entries
        # @directories.map { |directory| Dir.entries(directory).map { |d| directory + "/" + d } }.flatten.filter { |f| should_parse?(f) }

        @directories.select{ |directory| File.directory?(directory)}.map { |directory| Dir.entries(directory).map { |d| directory + "/" + d } }.flatten.select { |f| should_parse?(f) }
      rescue Errno::ENOENT
        []
      end

      def should_parse?(file)
        file !~ /\.$/
      end
    end
  end
end
