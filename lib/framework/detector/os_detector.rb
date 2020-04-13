# frozen_string_literal: true

require 'rbconfig'

class OsDetector
  include Singleton

  attr_reader :identifier, :version

  def initialize(*_args)
    @identifier = detect
    # @hierarchy = create_hierarchy(@identifier)
    @hierarchy
  end

  def hierarchy
    @hierarchy = custom_hierarchy(@identifier)
    @hierarchy || [@identifier.to_s.capitalize]
  end

  def detect
    host_os = RbConfig::CONFIG['host_os']
    @identifier = case host_os
                  when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
                    :windows
                  when /darwin|mac os/
                    :macosx
                  when /linux/
                    distro = detect_distro
                    @hierarchy = ['Linux', distro.to_s.capitalize]

                    distro
                  when /bsd/
                    :bsd
                  when /solaris/
                    :solaris
                  when /aix/
                    :aix
                  else
                    raise "unknown os: #{host_os.inspect}"
                  end
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

  def custom_hierarchy(operating_system)
    return [] unless operating_system

    case operating_system.to_sym
    when :fedora
      %w[El]
    when :amzn
      %w[El]
    when :rhel
      %w[El]
    when :centos
      %w[El]
    when :opensuse
      %w[Sles]
    when :bsd
      %w[Solaris Bsd]
    else
      nil
    end
  end
end
