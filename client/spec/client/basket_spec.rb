# frozen_string_literal: true

require "spec_helper"
# require 'cab_client/client/baskets'
RSpec.describe CabClient::Client::Baskets do
  before do
      CabClient.configure do |config|
        config.api_base =  ENV["API_BASE"]
        config.timeout = 200
      end
    end

  let(:client) { CabClient::Client.new }

  describe "#create_basket" do
    it "creates an empty basket" do
      VCR.use_cassette("create_empty_baskets") do
        response = client.create_basket
        parsed_body = JSON.parse(response.body.to_s)
        expect(response.status).to be_created
        expect(parsed_body.dig("basket", "id")).not_to be_nil
      end
    end

    it "creates a basket with some line items" do
      VCR.use_cassette("create_baskets_with_line_items") do
        response = client.create_basket(
          basket: {
            line_items: [
              product_code: "VOUCHER",
              quantity: 2,
            ],
          },
        )
        parsed_body = JSON.parse(response.body.to_s)
        expect(response.status).to be_created
        expect(parsed_body.dig("basket", "id")).not_to be_nil
        expect(parsed_body.dig("basket", "line_items").size).to eq(1)
      end
    end
  end

  describe "#retrieve_basket" do
    it "retrieves a previoulsy created basket" do
      VCR.use_cassette("create_empty_baskets_retrieve_non_existing_basket") do
        response = client.create_basket
        parsed_body = JSON.parse(response.body.to_s)
        expect(response.status).to be_created
        id = parsed_body.dig("basket", "id")

        VCR.use_cassette("retrieve_basket") do
          response = client.retrieve_basket(basket_id: id)
          parsed_body = JSON.parse(response.body.to_s)
          expect(response.status).to be_success
          expect(parsed_body.dig("basket", "id")).to eq(id)
        end
      end
    end

    it "failes whiles retrieving a non existing basket" do
      VCR.use_cassette("retrieve_non_existing_basket") do
        expect do
          client.retrieve_basket(basket_id: "non-existing")
        end.to raise_error(CabClient::Client::NotFoundError)
      end
    end
  end

  describe "#destroy_basket" do
    it "destroys a previoulsy created basket" do
      VCR.use_cassette("create_empty_baskets") do
        response = client.create_basket
        parsed_body = JSON.parse(response.body.to_s)
        expect(response.status).to be_created
        id = parsed_body.dig("basket", "id")

        VCR.use_cassette("destroy_basket") do
          response = client.destroy_basket(basket_id: id)
          parsed_body = JSON.parse(response.body.to_s)
          expect(response.status).to be_success
        end
      end
    end

    it "failes whiles destroying a non existing basket" do
      VCR.use_cassette("destroy_non_existing_basket") do
        expect do
          client.destroy_basket(basket_id: "non-existing")
        end.to raise_error(CabClient::Client::NotFoundError)
      end
    end
  end
end
