module Facter
  module Resolvers
    module Utils
      module File
        def safe_read(path)
          return '' unless File.readable?(path)
          File.read(path)
        end

        def safe_readlines(path)
          return [] unless File.readable?(path)
          File.readlines(path)
        end
      end
    end
  end
end
