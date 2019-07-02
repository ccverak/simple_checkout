# frozen_string_literal: true

require "securerandom"
require "concurrent"

module Cab
  module Repositories
    class ProductRepository
      def self.table
        $DATA[:products]
      end

      def self.all
        table.value
      end

      def self.create(code:, name:, price:)
        product = Models::Product.new(code, name, price)
        all << product

        product
      end

      def self.find(code)
        all.detect { |p| p.code == code }
      end

      def self.find!(id)
        product = find(id)

        if !product
          raise Cab::Errors::RecordNotFound.new("Product not found: #{id}")
        end

        product
      end

      def self.find_or_create_by(code:, name:, price:)
        Concurrent::atomically do
          product = find(code)
          if !product
            product = create(code: code, name: name, price: price)
          end

          product
        end
      end

      def self.seed
        [
          { code: "VOUCHER", name: "Cabify Voucher", price: 500 },
          { code: "TSHIRT", name: "Cabify T-Shirt", price: 2000 },
          { code: "MUG", name: "Cabify Coffee Mug", price: 750 },
        ].each do |product|
          find_or_create_by(product)
        end
      end
    end
  end
end
