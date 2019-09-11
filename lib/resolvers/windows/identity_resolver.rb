# frozen_string_literal: true

class IdentityResolver < BaseResolver
  NAME_SAM_COMPATIBLE = 2
  @log = Facter::Log.new
  class << self
    @@semaphore = Mutex.new
    @@fact_list ||= {}

    def resolve(fact_name)
      @@semaphore.synchronize do
        result ||= @@fact_list[fact_name]
        result || build_fact_list(fact_name)
      end
    end

    def invalidate_cache
      @@fact_list = {}
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

      [name_ptr.read_wide_string(size_ptr.read_uint32), privileged?]
    end

    def privileged?
      result = IdentityFFI::IsUserAnAdmin()
      result && result != FFI::WIN32_FALSE
    end

    def build_fact_list(fact_name)
      user, privileged = find_username
      @@fact_list[:user] = user
      @@fact_list[:privileged] = privileged
      @@fact_list[fact_name]
    end
  end
end
