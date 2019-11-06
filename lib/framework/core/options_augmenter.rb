# frozen_string_literal: true

module Facter
  class OptionsAugmenter
    include Facter::CliOptions
    include Facter::GlobalOptions
    include Facter::FactsOptions
    include Facter::QueryOptions

    attr_reader :options

    def initialize(options)
      @options = options.dup
    end
  end
end
