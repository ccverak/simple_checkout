# frozen_string_literal: true

module Cab
  module Repositories
    class AbstractRepository
      def self.table
        raise NotImplementedError
      end

      def self.all
        table.value
      end

      def self.find(_id)
        raise NotImplementedError
      end

      def self.find!(_id)
        raise NotImplementedError
      end

      def self.create(_attrs)
        raise NotImplementedError
      end

      def self.destroy!(_id)
        raise NotImplementedError
      end
    end
  end
end
