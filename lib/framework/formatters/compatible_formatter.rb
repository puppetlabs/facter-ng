module Facter
  class CompatibleFormatter
    def initialize
      @log = Log.new
    end

    def format(resolved_facts)
      hocon_formatter = HoconFactFormatter.new.format(resolved_facts)
      hocon_formatter.gsub!('=', ' => ')
      hocon_formatter.split("\n").map! { |line| line.match(/^[\s]+/) ? line : line.gsub(/,|\"/, '') }.join("\n")
      for_one_query(hocon_formatter)
    end

    def for_one_query(hocon_formatter)
      hocon_formatter = hocon_formatter.split("\n").map! { |line| '  ' + line }.join("\n")
      "{\n" + hocon_formatter + "\n}"
    end
  end
end
