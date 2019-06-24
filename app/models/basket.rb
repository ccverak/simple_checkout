# frozen_string_literal: true

require "pricing_rules"

module Cab
  module Models
    class Basket
      attr_accessor :id, :line_items

      def initialize(id, line_items)
        @id = id
        @line_items = line_items
      end

      def final_price
        price - discounts
      end

      def discounts
        return 0 if line_items.empty?

        PricingRules.active_rules.reduce(0) do |total, current_rule|
          total + current_rule.apply(self)
        end
      end

      def price
        line_items
          .map(&:price)
          .sum
      end
    end
  end
end
