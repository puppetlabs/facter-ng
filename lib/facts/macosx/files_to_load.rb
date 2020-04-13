require 'set'

module Facts
  module Macosx
    class Load
      class << self

        def files
          [
              'macosx',
          ]
        end

        def modules
          fact_modules = Set.new
          files.each do |fact_file|
            module_namespace_tokens = normalized_name_tokens(fact_file)
            fact_modules << "Facts::#{module_namespace_tokens.join('::')}"
          end
          fact_modules
        end

        private

        def normalized_name_tokens(fact_file)
          module_namespace_tokens = fact_file.split('/')[0..1]
          module_namespace_tokens.each_with_index do |token, index|
            if token.include?('_')
              module_namespace_tokens[index] = token.split('_').map { |word| word.capitalize! }.join
            else
              token.capitalize!
            end
          end
          module_namespace_tokens.last.sub!('.rb', '')
          module_namespace_tokens
        end

      end
    end
  end
end