# frozen_string_literal: true

module Facter
  module Resolvers
    class SystemProfiler < BaseResolver
      @log = Facter::Log.new(self)
      @semaphore = Mutex.new
      # NAME_HASH = { boot_rom_version: 'Boot ROM Version',
      #              cores: 'Total Number of Cores',
      #              hardware_uuid: 'Hardware UUID',
      #              l2_cache_per_core: 'L2 Cache (per Core)',
      #              l3_cache: 'L3 Cache',
      #              memory: 'Memory',
      #              model_identifier: 'Model Identifier',
      #              model_name: 'Model Name',
      #              processor_name: 'Processor Name',
      #              processor_speed: 'Processor Speed',
      #              processors: 'Number of Processors',
      #              serial_number: 'Serial Number (system)',
      #              smc_version: 'SMC Version (system)',
      #              boot_mode: 'Boot Mode',
      #              boot_volume: 'Boot Volume',
      #              computer_name: 'Computer Name',
      #              kernel_version: 'Kernel Version',
      #              secure_virtual_memory: 'Secure Virtual Memory',
      #              system_version: 'System Version',
      #              uptime: 'Time since boot',
      #              username: 'User Name' }.freeze

      # model_name
      # model_identifier
      # processor_name
      # processor_speed
      # number_of_processors
      # total_number_of_cores
      # l2_cache_per_core
      # l3_cache
      # hyper-threading_technology
      # memory
      # boot_rom_version
      # serial_number_system
      # hardware_uuid
      # activation_lock_status
      # system_version
      # kernel_version
      # boot_volume
      # boot_mode
      # computer_name
      # user_name
      # secure_virtual_memory
      # system_integrity_protection
      # time_since_boot

      class << self
        private

        def post_resolve(fact_name)
          retrieve_system_profiler(fact_name) if @fact_list.nil?

          @fact_list[fact_name]
        end

        def retrieve_system_profiler(fact_name)
          @fact_list ||= {}

          @log.debug 'Executing command: system_profiler SPSoftwareDataType SPHardwareDataType'
          output, _status = Open3.capture2('system_profiler SPHardwareDataType SPSoftwareDataType')
          @fact_list = output.scan(/.*:[ ].*$/).map { |e| e.strip.match(/(.*?): (.*)/).captures }.to_h
          @fact_list = @fact_list.map do |k, v|
            [k.downcase.gsub(' ', '_').gsub('(', '').gsub(')', '').to_sym, v]
          end.to_h

          @fact_list[fact_name]
        end
      end
    end
  end
end
