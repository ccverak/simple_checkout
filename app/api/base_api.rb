# frozen_string_literal: true

module CabWeb
  module API
    class BaseAPI < Grape::API
      include Defaults

      desc "This can act as a health endoint"
      get "/" do
        status :ok
        { version: Cab::VERSION }
      end
    end
  end
end
