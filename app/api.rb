module Cab
  class API < Grape::API
    prefix 'api'
    format :json

    mount Cab::HelloWorld

    add_swagger_documentation api_version: 'v1'
  end
end
