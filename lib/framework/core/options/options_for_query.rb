
module Facter
  class OptionsForQuery
    def initialize(options, user_query)
      @options = options
      @user_query = user_query
      augment!
    end

    def [](key)
      @options[key]
    end

    def []=(key, value)
      @options[key] = value
    end

    private

    def augment!
      @options[:user_query] = true if @user_query.any?
    end
  end
end
