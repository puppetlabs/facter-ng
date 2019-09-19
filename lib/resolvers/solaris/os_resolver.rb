# frozen_string_literal: true

class OsResolver < BaseResolver
  @log = Facter::Log.new
  class << self
    @@semaphore = Mutex.new
    @@fact_list ||= {}
    def resolve(fact_name)
      @@semaphore.synchronize do
        result ||= @@fact_list[fact_name]
        result || build_list(fact_name)
      end
    end

    private

    def determine_name
      result = UnameResolver.resolve(:kernelname)
      return 'Solaris' if result == 'SunOS'
    end

    def build_list(fact_name)
      @@fact_list[:name] = determine_name
      @@fact_list[fact_name]
    end
  end
end
