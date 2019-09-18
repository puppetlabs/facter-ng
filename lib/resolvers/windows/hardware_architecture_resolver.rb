# frozen_string_literal: true

class HardwareArchitectureResolver < BaseResolver
  @log = Facter::Log.new
  class << self
    @@semaphore = Mutex.new
    @@fact_list ||= {}

    def resolve(fact_name)
      @@semaphore.synchronize do
        result ||= @@fact_list[fact_name]
        result || build_facts_list(fact_name)
      end
    end

    def invalidate_cache
      @@fact_list = {}
    end

    private

    def read_hardware_information
      sys_info_ptr = FFI::MemoryPointer.new(SystemInfo.size)
      HardwareFFI::GetNativeSystemInfo(sys_info_ptr)
      sys_info = SystemInfo.new(sys_info_ptr)

      hard = determine_hardware(sys_info)
      arch = determine_architecture(hard)
      [hard, arch]
    end

    def determine_hardware(sys_info)
      dummyunionname = sys_info[:dummyunionname]
      dummystructname = dummyunionname[:dummystructname]
      case dummystructname[:wProcessorArchitecture]
      when HardwareFFI::PROCESSOR_ARCHITECTURE_AMD64
        'x86_64'
      when HardwareFFI::PROCESSOR_ARCHITECTURE_ARM
        'arm'
      when HardwareFFI::PROCESSOR_ARCHITECTURE_IA64
        'ia64'
      when HardwareFFI::PROCESSOR_ARCHITECTURE_INTEL
        family = sys_info[:wProcessorLevel] > 5 ? 6 : sys_info[:wProcessorLevel]
        "i#{family}86"
      else
        'unknown'
      end
    end

    def determine_architecture(hardware)
      case hardware
      when /i[3456]86/
        'x86'
      when 'x86_64'
        'x64'
      else
        hardware
      end
    end

    def build_facts_list(fact_name)
      hard, arch = read_hardware_information
      @@fact_list[:hardware] = hard
      @@fact_list[:architecture] = arch
      @@fact_list[fact_name]
    end
  end
end
