# frozen_string_literal: true

require "cab_client/configurable"
require "cab_client/version"

module CabClient
  class Error < StandardError; end
  extend Configurable

  
end

require "cab_client/client"
