
module Facter
  class OptionsAug
    include Facter::CliOptions
    include Facter::GlobalOptions
    include Facter::FactsOptions
    include Facter::QueryOptions

    def initialize(options)
      @options = options
    end

    def options
      @options
    end
  end
end