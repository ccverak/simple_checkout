# frozen_string_literal: true

describe "Pricing Rules Spec" do
  include Rack::Test::Methods

  def app
    Cab::API
  end

  it "applies the pricing rules as intended" do
    cases = [
      {
        products: ["VOUCHER", "TSHIRT", "MUG"],
        expected_price: 3250,
      },
      {
        products: ["VOUCHER", "TSHIRT", "VOUCHER"],
        expected_price: 2500,
      },
      {
        products: ["TSHIRT", "TSHIRT", "TSHIRT", "VOUCHER", "TSHIRT"],
        expected_price: 8100,
      },
      {
        products: ["VOUCHER", "TSHIRT", "VOUCHER", "VOUCHER", "MUG", "TSHIRT", "TSHIRT"],
        expected_price: 7450,
      },
    ]

    cases.each do |c|
      reset_db!
      products = c[:products]
      expected_price = c[:expected_price]

      basket_payload = {
        basket: {},
      }
      post "/api/v1/baskets", basket_payload
      expect(last_response.status).to eq(201)
      basket = JSON.parse(last_response.body).dig("basket")

      products.each do |product_code|
        line_item = {
          line_item: { product_code: product_code },
        }
        post "/api/v1/baskets/#{basket.fetch('id')}/line_items", line_item
        expect(last_response.status).to eq(201)
      end

      get "/api/v1/baskets/#{basket.fetch('id')}"
      parsed_response = JSON.parse(last_response.body)
      expect(parsed_response.dig("basket", "final_price")).to eq(expected_price)
    end
  end
end
