# frozen_string_literal: true

module Cab
  module PricingRules
    # Public API of the pricing rules module
    def self.active_rules
      active_rules = [
        { type: :two_for_one, product_code: "VOUCHER" },
        { type: :bulk, product_code: "TSHIRT", minimum_items: 3, discount_per_item: 100 },
      ]

      active_rules.map { |rule_hash| RuleFactory.call(rule_hash) }
    end

    # Private API
    class FreeItemsOnBatchRule
      attr_reader :product_code, :batch_size, :free_per_batch

      def initialize(product_code, batch_size, free_per_batch)
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

    class TwoForOneRule < FreeItemsOnBatchRule
      def initialize(product_code)
        super product_code, 2, 1
      end
    end

    class BulkRule
      attr_reader :product_code, :minimum_items, :discount_per_item

      def initialize(product_code, minimum_items, discount_per_item)
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

    class RuleFactory
      def self.call(pricing_rule)
        case pricing_rule[:type]
        when :free_items_on_batch
          FreeItemsOnBatchRule.new(pricing_rule[:product_code], pricing_rule[:batch_size], pricing_rule[:free_per_batch])
        when :two_for_one
          TwoForOneRule.new(pricing_rule[:product_code])
        when :bulk
          BulkRule.new(pricing_rule[:product_code], pricing_rule[:minimum_items], pricing_rule[:discount_per_item])
        else
          raise ArgumentError, "wrong rule type provided"
        end
      end
    end
  end
end
