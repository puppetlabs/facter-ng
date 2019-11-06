
module Facter
  class OptionsQueryAugmenter
    def initialize(user_query)
      @user_query = user_query
    end

    def augment!(options)
      options[:user_query] = true if @user_query.any?
    end
  end
end