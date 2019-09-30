# frozen_string_literal: true

module Facter
  module Resolvers
    class SolarisMemory < BaseResolver
      @log = Facter::Log.new
      @semaphore = Mutex.new
      @fact_list ||= {}

      class << self
        def resolve(fact_name)
          @semaphore.synchronize do
            result ||= @fact_list[fact_name]
            subscribe_to_manager
            result || build_facts(fact_name)
          end
        end

        private

        def build_facts(fact_name)
          kstat_output, kstat_status = Open3.capture2('/usr/bin/kstat -m unix -n system_pages')
          pagesize_output, pagesize_status = Open3.capture2('/usr/bin/pagesize')
          return if !kstat_status.to_s.include?('exit 0') || !pagesize_status.to_s.include?('exit 0')

          k_stat_result = extract_k_stat_result(kstat_output)
          page_size = pagesize_output.to_i
          total_memory = k_stat_result['physmem'].to_i * page_size
          free_memory = k_stat_result['pagesfree'].to_i * page_size
          @fact_list[:total_memory] = total_memory
          @fact_list[:free_memory]  = free_memory
          @fact_list[:used_memory] = total_memory - free_memory

          @fact_list[fact_name]
        end

        def extract_k_stat_result(output)
          result = {}
          output.split("\n")
                .map do |line|
            line.split(' ')
                .reject(&:empty?)
          end
                .each { |key, value| result[key] = value }
          result
        end
      end
    end
  end
end
