# frozen_string_literal: true

require 'rbconfig'
require 'singleton'

class CurrentOs
  include Singleton

  attr_accessor :slug, :version

  def detect
    @detect_family ||= begin
      host_os = RbConfig::CONFIG['host_os']
      case host_os
      when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
        :windows
      when /darwin|mac os/
        :macosx
      when /linux/
        detect_distro
      when /solaris|bsd/
        :unix
      when /aix/
        :aix
      else
        raise Error::WebDriverError, "unknown os: #{host_os.inspect}"
      end
    end
  end

  def detect_distro
    [OsReleaseResolver, RedHatReleaseResolver, SuseReleaseResolver].each do |resolver|
      slug = resolver.resolve(:slug)
      version = resolver.resolve(:version)
      break if slug

    end
    slug
  end
end
