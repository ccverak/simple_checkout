# frozen_string_literal: true

module CabWeb
  module API
    class BaseAPI < Grape::API
      default_format :json
      format :json
      content_type :json, "application/json"

      rescue_from :all do |e|
        Rollbar.error(e)
        BaseAPI.logger.error(e)
        error!(message: "Internal server error", status: 500)
      end

      desc "This is can act as a health endoint"
      get "/" do
        status :ok
        { version: Cab::VERSION }
      end
    end
  end
end
