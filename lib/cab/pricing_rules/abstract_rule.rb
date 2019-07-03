module Cab
  module PricingRules
    class AbstractRule
      def apply(basket)
        raise NotImpslementedError
      end
    end
  end
end
