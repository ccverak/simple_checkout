# frozen_string_literal: true

require "securerandom"
require "concurrent"
require "models/line_item"

module Cab
  module Repositories
    class LineItemRepository
      def self.table
        $DATA[:line_items]
      end

      def self.all
        table.value
      end

      def self.create(product:, quantity:)
        uuid = SecureRandom.uuid

        line_item = Models::LineItem.new(uuid, product, quantity)
        all << line_item

        line_item
      end

      def self.find(id)
        all.detect { |p| p.id == id }
      end

      def self.find!(id)
        line_item = find(id)

        if !line_item
          raise Cab::Errors::RecordNotFound.new("Line item not found: #{id}")
        end

        line_item
      end
    end
  end
end
