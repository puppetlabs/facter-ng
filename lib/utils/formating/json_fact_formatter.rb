# frozen_string_literal: true

module Facter
  class JsonFactFormatter
    def format(fact_hash)
      JSON.pretty_generate(fact_hash)
    end
  end
end
