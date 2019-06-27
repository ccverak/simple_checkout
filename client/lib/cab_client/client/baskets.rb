# frozen_string_literal: true

module CabClient
  class Client
    module Baskets
      def create_basket(attributes)
        perform_request(:post, "baskets", attributes)
      end

      def retrieve_basket(basket_id:)
        perform_request(:get, "baskets/#{basket_id}")
      end

      def destroy_basket(basket_id:)
        perform_request(:delete, "baskets/#{basket_id}")
      end
    end
  end
end
