# frozen_string_literal: true

module CabWeb
  module API
    module Defaults
      def self.included(base)
        base.class_eval do
          default_format :json
          format :json
          content_type :json, "application/json"

          logger.formatter = GrapeLogging::Formatters::Json.new
          unless ENV["RACK_ENV"] == "test"
            use GrapeLogging::Middleware::RequestLogger, logger: logger
          end

          rescue_from Grape::Exceptions::ValidationErrors do |e|
            logger.error(e) unless ENV["RACK_ENV"] == "test"

            error!(e, 400)
          end

          rescue_from Cab::Errors::RecordNotFound do |e|
            logger.error(e) unless ENV["RACK_ENV"] == "test"

            error!(e, 404)
          end

          rescue_from :all do |e|
            unless ENV["RACK_ENV"] == "test"
              Rollbar.error(e)

              logger.error(e)
            end
            error!(message: "Internal server error", status: 500)
          end

          helpers do
            def permitted_params
              @permitted_params ||= declared(params,
                                             include_missing: false)
            end

            def logger
              RootAPI.logger
            end
          end
        end
      end
    end
  end
end
