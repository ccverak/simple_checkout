# frozen_string_literal: true

require "rack/test"

ENV["RACK_ENV"] = "test"

require File.expand_path("../config/environment", __dir__)
def reset_db!
  $DATA = {
    products: Concurrent::TVar.new([]),
    line_items: Concurrent::TVar.new([]),
    baskets: Concurrent::TVar.new([]),
  }
  Cab::Repositories::ProductRepository.seed
end

RSpec.configure do |config|
  config.before(:each) do
    reset_db!
  end

  config.mock_with :rspec
  config.expect_with :rspec
  config.raise_errors_for_deprecations!
  config.order = "random"
end
