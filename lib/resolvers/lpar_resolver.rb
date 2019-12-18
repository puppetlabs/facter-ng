# frozen_string_literal: true

module Facter
  module Resolvers
    class Lpar < BaseResolver
      @semaphore = Mutex.new
      @fact_list ||= {}

      class << self
        def resolve(fact_name)
          @semaphore.synchronize do
            result ||= @fact_list[fact_name]
            subscribe_to_manager
            result || read_lpar(fact_name)
          end
        end

        def read_lpar(fact_name)
          lpar_cmd = '/usr/bin/lparstat -i'
          lpar_cmd += ' -W' if supports_wpar?
          output, _status = Open3.capture2(lpar_cmd)
          output.sub('WPAR Key', "\nWPAR Key").each_line do |line|
            populate_lpar_data(line.split(':').map(&:strip))
          end

          @fact_list[fact_name]
        end

        private

        def populate_lpar_data(key_value)
          @fact_list[:lpar_partition_name]   = key_value[1]      if key_value[0] == 'Partition Name'
          @fact_list[:lpar_partition_number] = key_value[1].to_i if key_value[0] == 'Partition Number'
          @fact_list[:wpar_key]              = key_value[1].to_i if key_value[0] == 'WPAR Key'
          @fact_list[:wpar_configured_id]    = key_value[1].to_i if key_value[0] == 'WPAR Configured ID'
        end

        def supports_wpar?
          @supports_wpar ||= begin
            output, _status = Open3.capture2('/usr/bin/oslevel 2>/dev/null')
            if output =~ /^(\d)\.(\d)/
              major = Regexp.last_match(1).to_i
              minor = Regexp.last_match(2).to_i
              major > 6 || (major == 6 && minor.positive?)
            end
          end
        end
      end
    end
  end
end
