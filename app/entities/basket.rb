# frozen_string_literal: true

module CabWeb
  module Entities
    module Basket
      class Request < Grape::Entity
        root "baskets", "basket"
        expose :line_items, using: Entities::LineItem, documentation: { type: Entities::LineItem, desc: "The list of line items" }
      end

      class Response < Grape::Entity
        root "baskets", "basket"
        expose :id, documentation: { type: String, desc: "The basket id" }
        expose :line_items, using: Entities::LineItem, documentation: { type: Entities::LineItem, desc: "The list of line items" }
        expose :price, documentation: { type: Integer, desc: "The total price of the basket in cents" }
        expose :final_price, documentation: { type: Integer, desc: "The final price of the basket in cents after discounts" }
        expose :discounts, documentation: { type: Integer, desc: "The discounts in cents" }
      end
    end
  end
end
