# frozen_string_literal: true

require 'pathname'

ROOT_DIR = Pathname.new(File.expand_path('../../..', __dir__)) unless defined?(ROOT_DIR)
require "#{ROOT_DIR}/lib/framework/core/file_loader"

module Facter
  def self.to_hash
    resolved_facts = Facter::Base.new.resolve_facts
    ResolverManager.invalidate_all_caches
    FactCollection.new.build_fact_collection!(resolved_facts)
  end

  def self.to_user_output(options, *args)
    resolved_facts = Facter::Base.new.resolve_facts(options, args)
    ResolverManager.invalidate_all_caches
    fact_formatter = Facter::FormatterFactory.build(options)
    fact_formatter.format(resolved_facts)
  end

  def self.value(user_query)
    resolved_facts = Facter::Base.new.resolve_facts({}, [user_query])
    ResolverManager.invalidate_all_caches
    fact_collection = FactCollection.new.build_fact_collection!(resolved_facts)
    fact_collection.dig(*user_query.split('.'))
  end

  def self.core_value(user_query)
    resolved_facts = Facter::Base.new.resolve_core({}, [user_query])
    fact_collection = FactCollection.new.build_fact_collection!(resolved_facts)
    fact_collection.dig(*user_query.split('.'))
  end
end
