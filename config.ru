# frozen_string_literal: true

require File.expand_path("config/environment", __dir__)

run Cab::API.new
