# frozen_string_literal: true

class LsbReleaseResolver < BaseResolver
  # "Distributor ID"
  # "Description"
  # "Release"
  # "Codename"

  class << self
    @@semaphore = Mutex.new
    @@fact_list ||= {}

    def resolve(fact_name)
      @@semaphore.synchronize do
        result ||= @@fact_list[fact_name]

        return result unless result.nil?

        output, _status = Open3.capture2('lsb_release -a')
        build_fact_list(output)

        return @@fact_list[fact_name]
      end
    end

    private

    def build_fact_list(output)
      release_info = output.delete("\t").split("\n").map { |e| e.split(':') }

      @@fact_list = Hash[*release_info.flatten]
      @@fact_list[:slug] = @@fact_list['Distributor ID'].downcase
    end
  end
end
