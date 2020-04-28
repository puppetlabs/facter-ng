# frozen_string_literal: true

module Facter
  module Resolvers
    module Macosx
      class Mountpoints < BaseResolver
        include Facter::FilesystemHelper
        @semaphore = Mutex.new
        @fact_list ||= {}
        @log = Facter::Log.new(self)
        class << self
          private

          def post_resolve(fact_name)
            @fact_list.fetch(fact_name) { read_mounts }
          end

          def read_mounts # rubocop:disable Metrics/AbcSize
            mounts = {}
            FilesystemHelper.read_mountpoints.each do |fs|
              device = fs.name.force_encoding('UTF-8')
              filesystem = fs.mount_type.force_encoding('UTF-8')
              path = fs.mount_point.force_encoding('UTF-8')
              options = fs.options.force_encoding('UTF-8').split(',').map(&:strip).map { |o| o == 'rootfs' ? 'root' : o }

              next if path =~ %r{^/(proc|sys)} && filesystem != 'tmpfs' || filesystem == 'autofs'

              mounts[path] = read_stats(path).tap do |hash|
                hash[:device] = device
                hash[:filesystem] = filesystem
                hash[:options] = options if options.any?
              end
            end

            @fact_list[:mountpoints] = mounts
          end

          def read_stats(path)
            begin
              stats = FilesystemHelper.read_mountpoint_stats(path)
              size_bytes = stats.bytes_total
              used_bytes = stats.bytes_used
              available_bytes = size_bytes - used_bytes
            rescue Sys::Filesystem::Error
              size_bytes = used_bytes = available_bytes = 0
            end

            {
              size_bytes: 2, #size_bytes,
              used_bytes: 2, #used_bytes,
              available_bytes: 2, #available_bytes,
              capacity: 2, #FilesystemHelper.compute_capacity(used_bytes, size_bytes),
              size:  2,#Facter::FactsUtils::UnitConverter.bytes_to_human_readable(size_bytes),
              available: 2, #Facter::FactsUtils::UnitConverter.bytes_to_human_readable(available_bytes),
              used: 2 # Facter::FactsUtils::UnitConverter.bytes_to_human_readable(used_bytes)
            }
          end
        end
      end
    end
  end
end
