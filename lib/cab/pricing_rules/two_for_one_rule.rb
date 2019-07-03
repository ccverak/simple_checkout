# frozen_string_literal: true

module Cab
  module PricingRules
    class TwoForOneRule < FreeItemsInBatchRule
      def initialize(product_code:)
        super product_code: product_code, batch_size: 2, free_per_batch: 1
      end
    end
  end
end
