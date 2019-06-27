# frozen_string_literal: true

module CabClient
  module Configurable
    OPTIONS = %i[api_base timeout].freeze

    attr_accessor(*OPTIONS)

    def configure
      yield self
    end
  end
end
