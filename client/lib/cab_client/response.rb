# frozen_string_literal: true

require 'oj'

module CabClient
  class Response < SimpleDelegator
    alias_method :object, :__getobj__

    def json
      Oj.load(object.body)
    end
  end
end
