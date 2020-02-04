# frozen_string_literal: true

require 'pathname'

ROOT_DIR = Pathname.new(File.expand_path('..', __dir__)) unless defined?(ROOT_DIR)

require "#{ROOT_DIR}/lib/framework/core/file_loader"
require "#{ROOT_DIR}/lib/framework/core/options/options_validator"

module Facter
  def self.to_hash
    options = { to_hash: true }
    resolved_facts = Facter::FactManager.instance.resolve_facts(options)
    CacheManager.invalidate_all_caches
    FactCollection.new.build_fact_collection!(resolved_facts)
  end

  def self.to_user_output(options, *args)
    resolved_facts = Facter::FactManager.instance.resolve_facts(options, args)
    CacheManager.invalidate_all_caches
    fact_formatter = Facter::FormatterFactory.build(options)

    if Options.instance[:strict]
      missing_names = args - resolved_facts.map(&:user_query).uniq
      if missing_names.count.positive?
        status = 1
        log_errors(missing_names)
      end
    end

    [fact_formatter.format(resolved_facts), status || 0]
  end

  def self.value(user_query)
    user_query = user_query.to_s
    resolved_facts = Facter::FactManager.instance.resolve_facts({}, [user_query])
    CacheManager.invalidate_all_caches
    fact_collection = FactCollection.new.build_fact_collection!(resolved_facts)
    fact_collection.dig(*user_query.split('.'))
  end

  def self.add(name, options = {}, &block)
    options[:fact_type] = :custom
    LegacyFacter.add(name, options, &block)
  end

  def self.reset
    LegacyFacter.reset
  end

  def self.search(*dirs)
    LegacyFacter.search(*dirs)
  end

  def self.search_external(dirs)
    LegacyFacter.search_external(dirs)
  end

  def self.core_value(user_query)
    user_query = user_query.to_s
    resolved_facts = Facter::FactManager.instance.resolve_core([user_query])
    fact_collection = FactCollection.new.build_fact_collection!(resolved_facts)
    fact_collection.dig(*user_query.split('.'))
  end

  def self.method_missing(name, *args, &block)
    log = Facter::Log.new(self)
    log.debug(
      "--#{name}-- not implemented but required \n" \
      'with params: ' \
      "#{args.inspect} \n" \
      'with block: ' \
      "#{block.inspect}  \n" \
      "called by:  \n" \
      "#{caller} \n"
    )
  end

  def self.debug(msg)
    @logger ||= Log.new(self)
    @logger.debug(msg)
  end

  def self.log_errors(missing_names)
    @logger ||= Log.new(self)

    missing_names.each do |missing_name|
      @logger.error("fact \"#{missing_name}\" does not exist.", true)
    end
  end
end
