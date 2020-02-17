# frozen_string_literal: true

module Facter
  class ZPoolZFSParser
    def self.feature_numbers_and_version(zfs: false, zpool: false)
      if zfs
        output, _status = Open3.capture2('zfs upgrade -v')
      elsif zpool
        output, _status = Open3.capture2('zpool upgrade -v')
      end
      features_list = output.scan(/^\s+(\d+)/).flatten
      feature_numbers = features_list.join(', ')
      version = features_list.last
      [feature_numbers, version]
    end
  end
end
