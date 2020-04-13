# frozen_string_literal: true

require 'rbconfig'

class OsDetector
  include Singleton

  attr_reader :identifier, :version

  def initialize(*_args)
    @os_hierarchy = Facter::OsHierarchy.new
    @identifier = detect
    # @hierarchy = create_hierarchy(@identifier)
  end

  def hierarchy
    @hierarchy
  end

  def detect
    host_os = RbConfig::CONFIG['host_os']
    @identifier = case host_os
                  when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
                    :windows
                  when /darwin|mac os/
                    :macosx
                  when /linux/
                    detect_distro
                  when /bsd/
                    :bsd
                  when /solaris/
                    :solaris
                  when /aix/
                    :aix
                  else
                    raise "unknown os: #{host_os.inspect}"
                  end

    @hierarchy = @os_hierarchy.construct_hierarchy(@identifier.to_s.capitalize)

    @identifier
  end

  private

  def detect_distro
    [Facter::Resolvers::OsRelease,
     Facter::Resolvers::RedHatRelease,
     Facter::Resolvers::SuseRelease].each do |resolver|
      @identifier = resolver.resolve(:identifier)
      @version = resolver.resolve(:version)
      break if @identifier
    end

    @identifier
  end
end
