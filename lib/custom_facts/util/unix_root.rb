module LegacyFacter
  module Util
    module Root
      def self.root?
        Process.uid == 0
      end
    end
  end
end
