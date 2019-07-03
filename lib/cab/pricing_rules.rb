# frozen_string_literal: true

require "cab/pricing_rules/abstract_rule"
require "cab/pricing_rules/free_items_in_batch"
require "cab/pricing_rules/bulk_rule"
require "cab/pricing_rules/two_for_one_rule"

module Cab
  module PricingRules
    # Public API of the pricing rules module
    def self.active_rules
      [
        TwoForOneRule.new(product_code: "VOUCHER"),
        BulkRule.new(product_code: "TSHIRT", minimum_items: 3, discount_per_item: 100),
      ]
    end
  end
end
