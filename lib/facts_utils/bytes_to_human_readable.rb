# frozen_string_literal: true

module Facter
  class BytesToHumanReadable
    class << self
      def convert(bytes)
        return unless bytes
        return bytes.to_s + ' bytes' if bytes < 1024

        units = %w[K M G T P E]
        result = determine_exponent(bytes)
        return bytes.to_s + ' bytes' if result[:exp] > units.size

        result[:converted_number].to_s + " #{units[result[:exp] - 1]}iB"
      end

      def convert_to_percentage(used_bytes, total_bytes)
        return '100%' if total_bytes == 0 || used_bytes >= total_bytes
        return '0%' if used_bytes == 0
        return ((10_000.0 * (used_bytes.to_f / total_bytes)).round / 100.0).to_s + '%'
      end

      private

      def determine_exponent(bytes)
        exp = (Math.log2(bytes) / 10.0).floor
        converted_number = (100.0 * (bytes / 1024.0**exp)).round / 100.0

        if (converted_number - 1024.0).abs < Float::EPSILON
          exp += 1
          converted_number = 1.00
        end
        { exp: exp, converted_number: converted_number }
      end
    end
  end
end
