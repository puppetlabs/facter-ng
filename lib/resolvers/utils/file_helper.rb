# frozen_string_literal: true

module Facter
  module Resolvers
    module Utils
      module FileHelper
        class << self
          def safe_read(path, return_if_not_readable = '')
            return return_if_not_readable unless File.readable?(path)

            File.read(path)
          end

          def safe_readlines(path, return_if_not_readable = [])
            return return_if_not_readable unless File.readable?(path)

            File.readlines(path)
          end
        end
      end
    end
  end
end
