# frozen_string_literal: true

require 'coveralls'
Coveralls.wear!

require 'bundler/setup'
require_relative '../lib/fact_loader'
require_relative '../lib/facts/linux/network_interface'

SimpleCov.start do
  track_files 'lib/**/*.rb'
end

SimpleCov.minimum_coverage 10

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

