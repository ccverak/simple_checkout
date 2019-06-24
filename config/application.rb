# frozen_string_literal: true

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "app"))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require "boot"

Bundler.require :default, ENV["RACK_ENV"]
require "dotenv/load"

require "cab"
require "api"
require "concurrent"
require "repositories/product_repository"

if ENV["ROLLBAR_TOKEN"]
  Rollbar.configure do |config|
    config.access_token = ENV["ROLLBAR_TOKEN"]
  end
end

$DATA = {
  products: Concurrent::TVar.new([]),
  line_items: Concurrent::TVar.new([]),
  baskets: Concurrent::TVar.new([]),
}

Cab::Repositories::ProductRepository.seed
