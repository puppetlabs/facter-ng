# frozen_string_literal: true

module Facter
  class FactFormater
    def format_facts(resolved_facts, formatter)
      formatter.format(resolved_facts)
    end
  end
end
