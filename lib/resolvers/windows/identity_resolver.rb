# frozen_string_literal: true

module Facter
  module Resolvers
    class IdentityResolver < BaseResolver
      NAME_SAM_COMPATIBLE = 2
      @log = Facter::Log.new
      @semaphore = Mutex.new
      @fact_list ||= {}

      class << self
        def resolve(fact_name)
          @semaphore.synchronize do
            result ||= @fact_list[fact_name]
            subscribe_to_manager
            result || retrieve_facts(fact_name)
          end
        end

        private

        def find_username
          size_ptr = FFI::MemoryPointer.new(:win32_ulong, 1)
          IdentityFFI::GetUserNameExW(NAME_SAM_COMPATIBLE, FFI::Pointer::NULL, size_ptr)
          if FFI.errno != ERROR_MORE_DATA
            @log.debug "failure resolving identity facts: #{FFI.errno}"
            return
          end

          name_ptr = FFI::MemoryPointer.new(:wchar, size_ptr.read_uint32)
          if IdentityFFI::GetUserNameExW(NAME_SAM_COMPATIBLE, name_ptr, size_ptr) == FFI::WIN32_FALSE
            @log.debug "failure resolving identity facts: #{FFI.errno}"
            return
          end

          { user: name_ptr.read_wide_string(size_ptr.read_uint32), privileged: privileged? }
        end

        def privileged?
          result = IdentityFFI::IsUserAnAdmin()
          result && result != FFI::WIN32_FALSE
        end

        def retrieve_facts(fact_name)
          result = find_username
          return unless result

          build_fact_list(result)
          @fact_list[fact_name]
        end

        def build_fact_list(facts)
          @fact_list[:user] = facts[:user]
          @fact_list[:privileged] = facts[:privileged]
        end
      end
    end
  end
end
