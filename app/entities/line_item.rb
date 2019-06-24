# frozen_string_literal: true

module Cab
  module Entities
    class LineItem < Grape::Entity
      root "line_items", "line_item"
      expose :product_code, documentation: { type: String, desc: "The product code", in: "body" }
      expose :quantity, documentation: { type: String, desc: "The number of items", in: "body" }
    end
  end
end
