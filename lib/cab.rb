# frozen_string_literal: true

module Cab
  VERSION = "0.0.1"
  module Errors
    class RecordNotFound < StandardError; end
  end
end

require "cab/repositories"
require "cab/models"
require "cab/pricing_rules"
