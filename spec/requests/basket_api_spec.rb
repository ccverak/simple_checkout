# frozen_string_literal: true

describe "Basket APIs" do
  include Rack::Test::Methods

  def app
    CabWeb::API::RootAPI
  end

  describe "POST /api/v1/basket" do
    it "creates an empty basket" do
      basket_payload = {
        basket: {},
      }
      post "/api/v1/baskets", basket_payload
      expect(last_response.status).to eq 201
    end

    it "creates the basket with a given list of line items" do
      basket_payload = {
        basket:
        {
          line_items: [
            { product_code: "VOUCHER" },
            { product_code: "MUG", quantity: 2 },
          ],
        },
      }
      post "/api/v1/baskets", basket_payload
      expect(last_response.status).to eq 201
      expect(JSON.parse(last_response.body).dig("basket").dig("line_items").size).to eq 2
    end
  end

  describe "DELETE /api/v1/basket/:id" do
    it "removes and existing basket" do
      basket_payload = {
        basket: {},
      }
      post "/api/v1/baskets", basket_payload
      basket = JSON.parse(last_response.body).dig("basket")

      delete "/api/v1/baskets/#{basket.fetch('id')}"
      expect(last_response.status).to eq(200)

      expect(Cab::Repositories::BasketRepository.find(basket.fetch("id"))).to be_nil
    end

    it "returns 404 when the basked doesnt exist" do
      non_existing_id = 10000
      delete "/api/v1/baskets/#{non_existing_id}"
      expect(last_response.status).to eq(404)
    end
  end

  describe "POST /api/v1/basket/:id/line_items" do
    it "Adds a product to the basket" do
      basket_payload = {
        basket: {},
      }
      post "/api/v1/baskets", basket_payload
      basket = JSON.parse(last_response.body).dig("basket")

      new_line_item = {
        line_item: { product_code: "VOUCHER" },
      }
      post "/api/v1/baskets/#{basket.fetch('id')}/line_items", new_line_item
      expect(last_response.status).to eq(201)
      parsed_response = JSON.parse(last_response.body)
      expect(parsed_response.dig("basket").dig("line_items").size).to eq 1
      expect(parsed_response.dig("basket").dig("line_items")).to include("product_code" => "VOUCHER", "quantity" => 1)
    end

    it "returns 404 when the basked doesnt exist" do
      non_existing_id = 10000
      new_line_item = {
        line_item: { product_code: "VOUCHER" },
      }
      post "/api/v1/baskets/#{non_existing_id}/line_items", new_line_item
      expect(last_response.status).to eq(404)
    end
  end

  describe "GET /api/v1/basket/:id" do
    it "Retrieves a basket by its id" do
      basket_payload = {
        basket: {
          line_items: [
            { product_code: "VOUCHER" },
          ],
        },
      }
      post "/api/v1/baskets", basket_payload
      basket = JSON.parse(last_response.body).dig("basket")

      get "/api/v1/baskets/#{basket.fetch('id')}"
      expect(last_response.status).to eq(200)
      parsed_response = JSON.parse(last_response.body)
      expect(parsed_response.dig("basket").dig("line_items").size).to eq 1
      expect(parsed_response.dig("basket").dig("line_items")).to include("product_code" => "VOUCHER", "quantity" => 1)
    end

    it "returns 404 when the basked doesnt exist" do
      non_existing_id = 10000
      get "/api/v1/baskets/#{non_existing_id}"
      expect(last_response.status).to eq(404)
    end
  end
end
