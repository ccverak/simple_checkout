# frozen_string_literal: true

module Cab
  module Models
    class LineItem
      attr_reader :id, :product, :quantity

      def initialize(id, product, quantity)
        @id = id
        @product = product
        @quantity = quantity
      end

      def price
        @product.price * quantity
      end

      def product_code
        @product.code
      end
    end
  end
end
