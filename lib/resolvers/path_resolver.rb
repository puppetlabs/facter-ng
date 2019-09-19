# frozen_string_literal: true

class PathResolver < BaseResolver
  class << self
    @@semaphore = Mutex.new
    @@fact_list ||= {}

    def resolve(fact_name)
      @@semaphore.synchronize do
        result ||= @@fact_list[fact_name]
        result || read_path_from_env
      end
    end

    private

    def read_path_from_env
      @@fact_list[:path] = ENV['PATH'].strip
    end
  end
end
