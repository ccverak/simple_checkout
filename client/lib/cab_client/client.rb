# frozen_string_literal: true

require "cab_client/response"
require "cab_client/client/baskets"
require "cab_client/client/line_items"
require "http"

module CabClient
  class Client
    include Client::Baskets
    include Client::LineItems

    class NotFoundError < StandardError; end
    class ServerError < StandardError; end
    class IncompatibleClientError < StandardError; end
    class TimeoutError < StandardError; end

    DEFAULT_TIMEOUT = 10
    attr_reader(*Configurable::OPTIONS)

    def initialize(options = {})
      Configurable::OPTIONS.each do |key|
        instance_variable_set(:"@#{key}", options[key] || CabClient.send(key))
      end

      @api_base ||= https://cab-api-prod.herokuapp.com/api/v1
      @timeout ||= DEFAULT_TIMEOUT
    end

    private

    def http_client
      @http_client ||= HTTP.timeout(connect: timeout)
    end

    def perform_request(method, path, params = {})
      url = "#{api_base}/#{path}"

      handle_errors do
        Response.new(http_client.send(method, url, json: params))
      end
    end

    def handle_errors
      yield.tap do |response|
        if response.status.request_timeout?
          raise APINotAvailable, "The request timed out, please try again"
        elsif response.status.server_error?
          raise ServerError, "Something seems odd in the server side, please try again later"
        elsif response.status.not_found?
          raise NotFoundError, response.body.to_s
        elsif response.status.client_error?
          raise IncompatibleClientError, "Seems you are using an old client, please update to the latest version"\
                                         "Upstream error: #{response.body.to_s}"
        end
      end
    end
  end
end
