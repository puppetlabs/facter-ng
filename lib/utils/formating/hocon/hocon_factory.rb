# frozen_string_literal: true

module Facter
  class HoconFactory
    def construct_hocon_parser(fact_hash)
      if fact_hash.length == 1
        HoconSingleValue.new(fact_hash)
      else
        HoconMultipleValues.new(fact_hash)
      end
    end
  end
end
