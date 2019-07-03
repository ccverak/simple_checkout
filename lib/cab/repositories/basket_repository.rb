# frozen_string_literal: true

require "securerandom"

module Cab
  module Repositories
    class BasketRepository < AbstracRepository
      def self.table
        $DATA[:baskets]
      end

      def self.find(id)
        all
          .detect { |basket| basket.id == id }
      end

      def self.find!(id)
        basket = find(id)

        if !basket
          raise Cab::Errors::RecordNotFound.new("Basket not found: #{id}")
        end

        basket
      end

      def self.add_line_item(id, line_item)
        Concurrent::atomically do
          basket = find!(id)

          product = ProductRepository.find!(line_item[:product_code])
          new_line_item = LineItemRepository.create(product: product, quantity: line_item[:quantity])
          basket.line_items << new_line_item

          basket
        end
      end

      def self.create(line_items_params = [])
        Concurrent::atomically do
          line_items = line_items_params.map do |item|
            quantity = item[:quantity]
            product = ProductRepository.find!(item[:product_code])
            LineItemRepository.create(product: product, quantity: quantity)
          end

          uuid = SecureRandom.uuid
          basket = Models::Basket.new(uuid, line_items)
          all << basket

          basket
        end
      end

      def self.destroy!(id)
        Concurrent::atomically do
          basket = find!(id)
          all.delete(basket)
        end
      end
    end
  end
end
