# frozen_string_literal: true

require "spec_helper"
# require 'cab_client/client/baskets'
RSpec.describe CabClient::Client::LineItems do
  before do
    CabClient.configure do |config|
      config.api_base = ENV["API_BASE"]
      config.timeout = 200
    end
  end

  let(:client) { CabClient::Client.new }

  describe "#add_to_basket" do
    it "adds a line item to an existing basket" do
      VCR.use_cassette("add_line_items_create_empty_basket") do
        response = client.create_basket
        parsed_body = JSON.parse(response.body.to_s)
        expect(response.status).to be_created
        id = parsed_body.dig("basket", "id")
        VCR.use_cassette("add_line_item_to_basket") do
          response = client.add_to_basket(basket_id: id, attributes: {
                                            line_item: {
                                              product_code: "VOUCHER",
                                              quantity: 2,
                                            },
                                          })
          parsed_body = JSON.parse(response.body.to_s)
          expect(response.status).to be_success
          expect(parsed_body.dig("basket", "id")).to eq(id)
          expect(parsed_body.dig("basket", "line_items").size).to eq(1)
          expect(parsed_body.dig("basket", "line_items").first.dig("product_code")).to eq("VOUCHER")
        end
      end
    end

    it "fails when trying to add line items to a non existing basket" do
      VCR.use_cassette("add_line_item_to_non_existing_basket") do
        expect do
          client.add_to_basket(basket_id: "non-existing-id", attributes: {
                                 line_item: {
                                   product_code: "VOUCHER",
                                   quantity: 2,
                                 },
                               })
        end.to raise_error(CabClient::Client::NotFoundError)
      end
    end

    it "adds a line item to an existing basket" do
      VCR.use_cassette("add_line_items_existing_basket_invalid_product_code") do
        response = client.create_basket
        parsed_body = JSON.parse(response.body.to_s)
        expect(response.status).to be_created
        id = parsed_body.dig("basket", "id")
        VCR.use_cassette("add_line_item_to_basket_invalid_product_code") do
          expect do
            client.add_to_basket(basket_id: id, attributes: {
                                   line_item: {
                                     product_code: "NON-EXISTNG-CODE",
                                     quantity: 2,
                                   },
                                 })
          end.to raise_error(CabClient::Client::NotFoundError)
        end
      end
    end
  end
end
