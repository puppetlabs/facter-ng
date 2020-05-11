# frozen_string_literal: true

# This class acts as the factory and parent class for parsed
# facts such as scripts, text, json and yaml files.
#
# Parsers must subclass this class and provide their own #results method.

# module Psych
#   class ScalarScanner
#     def parse_time string
#       string
#     end
#   end
# end

class MyScanner < Psych::ScalarScanner
  def parse_time string
    string
  end
end


module MyPsych
  include Psych

  def self.safe_load yaml, legacy_permitted_classes = NOT_GIVEN, legacy_permitted_symbols = NOT_GIVEN, legacy_aliases = NOT_GIVEN, legacy_filename = NOT_GIVEN, permitted_classes: [], permitted_symbols: [], aliases: false, filename: nil, fallback: nil, symbolize_names: false
    if legacy_permitted_classes != NOT_GIVEN
      warn_with_uplevel 'Passing permitted_classes with the 2nd argument of Psych.safe_load is deprecated. Use keyword argument like Psych.safe_load(yaml, permitted_classes: ...) instead.', uplevel: 1 if $VERBOSE
      permitted_classes = legacy_permitted_classes
    end

    if legacy_permitted_symbols != NOT_GIVEN
      warn_with_uplevel 'Passing permitted_symbols with the 3rd argument of Psych.safe_load is deprecated. Use keyword argument like Psych.safe_load(yaml, permitted_symbols: ...) instead.', uplevel: 1 if $VERBOSE
      permitted_symbols = legacy_permitted_symbols
    end

    if legacy_aliases != NOT_GIVEN
      warn_with_uplevel 'Passing aliases with the 4th argument of Psych.safe_load is deprecated. Use keyword argument like Psych.safe_load(yaml, aliases: ...) instead.', uplevel: 1 if $VERBOSE
      aliases = legacy_aliases
    end

    if legacy_filename != NOT_GIVEN
      warn_with_uplevel 'Passing filename with the 5th argument of Psych.safe_load is deprecated. Use keyword argument like Psych.safe_load(yaml, filename: ...) instead.', uplevel: 1 if $VERBOSE
      filename = legacy_filename
    end

    result = Psych::parse(yaml, filename: filename)
    return fallback unless result

    class_loader = Psych::ClassLoader::Restricted.new(permitted_classes.map(&:to_s),
                                                      permitted_symbols.map(&:to_s))
    scanner      = MyScanner.new class_loader
    visitor = if aliases
                Psych::Visitors::ToRuby.new scanner, class_loader
              else
                Psych::Visitors::NoAliasRuby.new scanner, class_loader
              end
    result = visitor.accept result
    Psych.symbolize_names!(result) if symbolize_names
    result
  end
end


module Test
  refine Psych::ScalarScanner do
    def parse_time string
      string
    end
  end

  refine Psych.singleton_class do
    NOT_GIVEN = Object.new
    def safe_load yaml, legacy_permitted_classes = NOT_GIVEN, legacy_permitted_symbols = NOT_GIVEN, legacy_aliases = NOT_GIVEN, legacy_filename = NOT_GIVEN, permitted_classes: [], permitted_symbols: [], aliases: false, filename: nil, fallback: nil, symbolize_names: false
        if legacy_permitted_classes != NOT_GIVEN
          warn_with_uplevel 'Passing permitted_classes with the 2nd argument of Psych.safe_load is deprecated. Use keyword argument like Psych.safe_load(yaml, permitted_classes: ...) instead.', uplevel: 1 if $VERBOSE
          permitted_classes = legacy_permitted_classes
        end

        if legacy_permitted_symbols != NOT_GIVEN
          warn_with_uplevel 'Passing permitted_symbols with the 3rd argument of Psych.safe_load is deprecated. Use keyword argument like Psych.safe_load(yaml, permitted_symbols: ...) instead.', uplevel: 1 if $VERBOSE
          permitted_symbols = legacy_permitted_symbols
        end

        if legacy_aliases != NOT_GIVEN
          warn_with_uplevel 'Passing aliases with the 4th argument of Psych.safe_load is deprecated. Use keyword argument like Psych.safe_load(yaml, aliases: ...) instead.', uplevel: 1 if $VERBOSE
          aliases = legacy_aliases
        end

        if legacy_filename != NOT_GIVEN
          warn_with_uplevel 'Passing filename with the 5th argument of Psych.safe_load is deprecated. Use keyword argument like Psych.safe_load(yaml, filename: ...) instead.', uplevel: 1 if $VERBOSE
          filename = legacy_filename
        end

        result = Psych::parse(yaml, filename: filename)
        return fallback unless result

        class_loader = Psych::ClassLoader::Restricted.new(permitted_classes.map(&:to_s),
                                                   permitted_symbols.map(&:to_s))
        scanner      = MyScanner.new class_loader
        visitor = if aliases
                    Psych::Visitors::ToRuby.new scanner, class_loader
                  else
                    Psych::Visitors::NoAliasRuby.new scanner, class_loader
                  end
        result = visitor.accept result
        Psych.symbolize_names!(result) if symbolize_names
        result
    end
  end
end

# require 'yaml'

# using ::Test

module LegacyFacter
  module Util
    module Parser
      @parsers = []

      # For support mutliple extensions you can pass an array of extensions as
      # +ext+.
      def self.extension_matches?(filename, ext)
        extension = case ext
                    when String
                      ext.downcase
                    when Enumerable
                      ext.collect(&:downcase)
                    end
        [extension].flatten.to_a.include?(file_extension(filename).downcase)
      end

      def self.file_extension(filename)
        File.extname(filename).sub('.', '')
      end

      def self.register(klass, &suitable)
        @parsers << [klass, suitable]
      end

      def self.parser_for(filename)
        registration = @parsers.detect { |k| k[1].call(filename) }

        if registration.nil?
          NothingParser.new
        else
          registration[0].new(filename)
        end
      end

      class Base
        attr_reader :filename

        def initialize(filename, content = nil)
          @filename = filename
          @content  = content
        end

        def content
          @content ||= Facter::Util::FileHelper.safe_read(filename, nil)
        end

        # results on the base class is really meant to be just an exception handler
        # wrapper.
        def results
          parse_results
        rescue Exception => e
          Facter.log_exception(e, "Failed to handle #{filename} as #{self.class} facts: #{e.message}")
          nil
        end

        def parse_results
          raise ArgumentError, 'Subclasses must respond to parse_results'
        end

        def parse_executable_output(output)
          res = nil
          begin
            res = YAML.safe_load output
          rescue Exception => e
            Facter.debug("Could not parse executable fact output as YAML or JSON (#{e.message})")
          end
          res = KeyValuePairOutputFormat.parse output unless res.is_a?(Hash)
          res
        end
      end

      module KeyValuePairOutputFormat
        def self.parse(output)
          return {} if output.nil?

          result = {}
          re = /^(.+?)=(.+)$/
          output.each_line do |line|
            if (match_data = re.match(line.chomp))
              result[match_data[1]] = match_data[2]
            end
          end
          result
        end
      end

      # This regex was taken from Psych
      # https://github.com/ruby/psych/blob/d2deaa9adfc88fc0b870df022a434d6431277d08/lib/psych/scalar_scanner.rb#L9
      # It is used to detect Time in YAML, but we use it wrap time objects in quotes to be treated as strings.
      TIME =
        /^-?\d{4}-\d{1,2}-\d{1,2}(?:[Tt]|\s+)\d{1,2}:\d\d:\d\d(?:\.\d*)?(?:\s*(?:Z|[-+]\d{1,2}:?(?:\d\d)?))?$/.freeze

      class YamlParser < Base
        using ::Test

        def parse_results

          # require 'psych'
          # ss = Psych::ScalarScanner.new("cl")
          # ss.parse_time("tt")

          # yaml_hash = Psych.sl(content, [Date, Time])
          yaml_hash = MyPsych.safe_load(content, [Date, Time])

          # add quotes to YAML time in order to interpret is as string
          # yaml_stream = Psych.parse_stream(yaml_hash.to_yaml)
          # yaml_stream
          #   .grep(Psych::Nodes::Scalar)
          #   .select { |node| node.value =~ TIME }
          #   .each do |node|
          #     node.plain  = true
          #     # node.quoted = true
          #     node.tag = "!!str"
          #     node.value = node.value.to_s
          # end
          #
          # YAML.safe_load(yaml_stream.yaml, [Date, Time])

          yaml_hash
        end
      end

      register(YamlParser) do |filename|
        extension_matches?(filename, 'yaml')
      end

      class TextParser < Base
        def parse_results
          KeyValuePairOutputFormat.parse content
        end
      end

      register(TextParser) do |filename|
        extension_matches?(filename, 'txt')
      end

      class JsonParser < Base
        def parse_results
          if LegacyFacter.json?
            JSON.parse(content)
          else
            LegacyFacter.warnonce "Cannot parse JSON data file #{filename} without the json library."
            LegacyFacter.warnonce 'Suggested next step is `gem install json` to install the json library.'
            nil
          end
        end
      end

      register(JsonParser) do |filename|
        extension_matches?(filename, 'json')
      end

      class ScriptParser < Base
        def parse_results
          parse_executable_output(Facter::Core::Execution.exec(quote(filename)))
        end

        private

        def quote(filename)
          filename.index(' ') ? "\"#{filename}\"" : filename
        end
      end

      register(ScriptParser) do |filename|
        if LegacyFacter::Util::Config.windows?
          extension_matches?(filename, %w[bat cmd com exe]) && FileTest.file?(filename)
        else
          File.executable?(filename) && FileTest.file?(filename) && !extension_matches?(filename, %w[bat cmd com exe])
        end
      end

      # Executes and parses the key value output of Powershell scripts
      class PowershellParser < Base
        # Returns a hash of facts from powershell output
        def parse_results
          powershell =
            if File.readable?("#{ENV['SYSTEMROOT']}\\sysnative\\WindowsPowershell\\v1.0\\powershell.exe")
              "#{ENV['SYSTEMROOT']}\\sysnative\\WindowsPowershell\\v1.0\\powershell.exe"
            elsif File.readable?("#{ENV['SYSTEMROOT']}\\system32\\WindowsPowershell\\v1.0\\powershell.exe")
              "#{ENV['SYSTEMROOT']}\\system32\\WindowsPowershell\\v1.0\\powershell.exe"
            else
              'powershell.exe'
            end

          shell_command =
            "\"#{powershell}\" -NoProfile -NonInteractive -NoLogo -ExecutionPolicy Bypass -File \"#{filename}\""
          output = Facter::Core::Execution.exec(shell_command)
          parse_executable_output(output)
        end
      end

      register(PowershellParser) do |filename|
        LegacyFacter::Util::Config.windows? && extension_matches?(filename, 'ps1') && FileTest.file?(filename)
      end

      # A parser that is used when there is no other parser that can handle the file
      # The return from results indicates to the caller the file was not parsed correctly.
      class NothingParser
        def results
          nil
        end
      end
    end
  end
end
