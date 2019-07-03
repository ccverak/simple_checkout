# frozen_string_literal: true

require "bundler/setup"
require "cab_client"
require "vcr"

ENV["API_BASE"] = "https://cab-api-prod.herokuapp.com/api/v1"

VCR.configure do |config|
  config.cassette_library_dir = "fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.default_cassette_options = {
    match_requests_on: %i[method host path],
    re_record_interval: 7 * 24 * 60 * 60,
  }
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
