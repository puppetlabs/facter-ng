# frozen_string_literal: true

require "#{ROOT_DIR}/lib/utils/formating/hocon/hocon_factory"
require "#{ROOT_DIR}/lib/utils/formating/hocon/hocon_utils"
require "#{ROOT_DIR}/lib/utils/formating/hocon/hocon_multiple_values"
require "#{ROOT_DIR}/lib/utils/formating/hocon/hocon_single_value"

module Facter
  class HoconFactFormatter
    def format(fact_hash)
      hocon_parser = HoconFactory.new.construct_hocon_parser(fact_hash)
      hocon_parser.to_hocon
    end
  end
end
