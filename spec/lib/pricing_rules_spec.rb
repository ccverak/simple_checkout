# frozen_string_literal: true

describe "PricingRules" do
  describe "FreeItemsInBatchRule" do
    it "discounts the price of a 'y' of products for every 'x' of them in the basket" do
      basket = Cab::Repositories::BasketRepository.create
      Cab::Repositories::BasketRepository.add_line_item(basket.id, product_code: "VOUCHER", quantity: 5)

      fib = Cab::PricingRules::FreeItemsInBatchRule.new(product_code: "VOUCHER", batch_size: 2, free_per_batch: 1)
      discount = fib.apply(basket)

      expected = 1000
      expect(discount).to eq expected

      fib = Cab::PricingRules::FreeItemsInBatchRule.new(product_code: "VOUCHER", batch_size: 3, free_per_batch: 2)
      discount = fib.apply(basket)

      expected = 1000
      expect(discount).to eq expected
    end
  end

  describe "TwoForOneRule" do
    it "discounts the price of 1 product for every 2 products of its type in the basket" do
      basket = Cab::Repositories::BasketRepository.create
      Cab::Repositories::BasketRepository.add_line_item(basket.id, product_code: "VOUCHER", quantity: 1)
      Cab::Repositories::BasketRepository.add_line_item(basket.id, product_code: "VOUCHER", quantity: 1)

      fib = Cab::PricingRules::TwoForOneRule.new(product_code: "VOUCHER")
      discount = fib.apply(basket)

      expected = 500
      expect(discount).to eq expected
    end
  end

  describe "BulkRule" do
    it "discounts the a given amount of money for every unit when there are more than a number of the product in the basket" do
      basket = Cab::Repositories::BasketRepository.create
      Cab::Repositories::BasketRepository.add_line_item(basket.id, product_code: "VOUCHER", quantity: 1)
      Cab::Repositories::BasketRepository.add_line_item(basket.id, product_code: "VOUCHER", quantity: 1)
      Cab::Repositories::BasketRepository.add_line_item(basket.id, product_code: "VOUCHER", quantity: 1)
      Cab::Repositories::BasketRepository.add_line_item(basket.id, product_code: "VOUCHER", quantity: 1)
      Cab::Repositories::BasketRepository.add_line_item(basket.id, product_code: "VOUCHER", quantity: 1)

      fib = Cab::PricingRules::BulkRule.new(product_code: "VOUCHER", minimum_items: 5, discount_per_item: 100)
      discount = fib.apply(basket)

      expected = 500
      expect(discount).to eq expected
    end
  end
end
