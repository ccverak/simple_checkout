# frozen_string_literal: true

require "cab"
require "apis/base_api"
require "apis/basket_api"

module Cab
  class API < Grape::API
    version "v1"
    prefix "api"
    default_format :json
    content_type :json, "application/json"
    format :json

    mount Apis::BaseAPI
    mount Apis::BasketAPI

    add_swagger_documentation mount_path: "/docs",
                              info: {
                                title: "Cab's API definitions",
                                description: "An API that allows users to manage checkout baskets",
                                contact_name: "Carlos Castellanos",
                                contact_email: "carloscastellanosvera@gmail.com",
                                contact_url: "https://github.com/ccverak",
                                license: "MIT",
                                license_url: "https://opensource.org/licenses/MIT",
                                terms_of_service_url: "www.The-URL-of-the-terms-and-service.com",
                              }
  end
end
