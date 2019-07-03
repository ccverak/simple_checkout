# frozen_string_literal: true

module CabClient
  class Client
    module LineItems
      def add_to_basket(basket_id:, attributes:)
        perform_request(:post, "/baskets/#{basket_id}/line_items", attributes)
      end
    end
  end
end
