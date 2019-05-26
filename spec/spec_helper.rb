require "bundler/setup"
require "tataru"
require "tataru/core"
require "active_support"
require "active_support/core_ext"
require 'active_support/testing/time_helpers'
require 'webmock'

Aws.config[:stub_responses] = true
include WebMock::API

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.include ActiveSupport::Testing::TimeHelpers

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
