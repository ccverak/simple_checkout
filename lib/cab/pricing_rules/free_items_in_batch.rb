# frozen_string_literal: true

module Cab
  module PricingRules
    class FreeItemsInBatchRule < AbstractRule
      attr_reader :product_code, :batch_size, :free_per_batch

      def initialize(product_code:, batch_size:, free_per_batch:)
        @product_code = product_code
        @batch_size = batch_size
        @free_per_batch = free_per_batch
      end

      def apply(basket)
        line_items = basket.line_items.select { |li| li.product.code == product_code }
        return 0 if line_items.empty?

        price = line_items.first.product.price
        total = line_items.map(&:quantity).sum

        discount = total / batch_size * free_per_batch * price
        discount
      end
   end
  end
end
