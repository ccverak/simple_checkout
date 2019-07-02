# frozen_string_literal: true

module CabWeb
  module Entities
    module Product
      class Response < Grape::Entity
        root "products", "product"
        expose :code, documentation: { type: String, desc: "The product code" }
        expose :name, documentation: { type: String, desc: "The product name" }
        expose :price, documentation: { type: Integer, desc: "The product price in cents" }
      end
    end
  end
end
