module Cab
  module PricingRules
    class BulkRule < AbstractRule
      attr_reader :product_code, :minimum_items, :discount_per_item

      def initialize(product_code:, minimum_items:, discount_per_item:)
        @product_code = product_code
        @minimum_items = minimum_items
        @discount_per_item = discount_per_item
      end

      def apply(basket)
        line_items = basket.line_items.select { |li| li.product.code == product_code }
        return 0 if line_items.empty?

        total = line_items.map(&:quantity).sum

        discount = (total >= minimum_items ? discount_per_item : 0) * total
        discount
      end
    end
  end
end
