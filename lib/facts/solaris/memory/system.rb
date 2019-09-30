# frozen_string_literal: true

module Facter
  module Solaris
    class MemorySystem
      FACT_NAME = 'memory.system'

      def call_the_resolver
        free_memory_bytes = Facter::Resolvers::SolarisMemory.resolve(:free_memory)
        total_memory_bytes = Facter::Resolvers::SolarisMemory.resolve(:total_memory)
        used_memory_bytes = Facter::Resolvers::SolarisMemory.resolve(:used_memory)
        system_memory = {
          available_bytes: free_memory_bytes,
          available: BytesToHumanReadable.convert(free_memory_bytes),
          total_bytes: total_memory_bytes,
          total: BytesToHumanReadable.convert(total_memory_bytes),
          used_bytes: used_memory_bytes,
          used: BytesToHumanReadable.convert(used_memory_bytes),
          capacity: BytesToHumanReadable.convert_to_percentage(used_memory_bytes, total_memory_bytes)
        }
        ResolvedFact.new(FACT_NAME, system_memory)
      end
    end
  end
end
