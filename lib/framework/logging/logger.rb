# frozen_string_literal: true

module Facter
  RED = 31

  class Log
    @@level = :warn

    def initialize(logged_class, is_cli = false)
      determine_callers_name(logged_class)
      @logger = MultiLogger.new
      @logger.set_format
      @logger.level = @@level
    end

    def determine_callers_name(sender_self)
      @class_name = sender_self.class.name != 'Class' ? sender_self.class.name : sender_self.name
    end

    def self.level=(log_level)
      @@level = log_level
      @logger.level = @@level if defined?(@logger)
    end

    def self.level
      @logger.level
    end

    def debug(msg)
      @logger.debug(@class_name + ' - ' + msg)
    end

    def info(msg)
      @logger.info(@class_name + ' - ' + msg)
    end

    def warn(msg)
      @logger.warn(@class_name + ' - ' + msg)
    end

    def error(msg, colorize = false)
      msg = colorize(msg, RED) if colorize && !OsDetector.instance.detect.eql?(:windows)
      @logger.error(@class_name + ' - ' + msg)
    end

    def colorize(msg, color)
      "\e[#{color}m#{msg}\e[0m"
    end
  end
end
