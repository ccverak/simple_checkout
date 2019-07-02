# frozen_string_literal: true

module CabWeb
  module API
    class BasketAPI < Grape::API
      default_format :json
      format :json
      content_type :json, "application/json"

      rescue_from Grape::Exceptions::ValidationErrors do |e|
        BasketAPI.logger.error(e)

        error!(e, 400)
      end

      rescue_from Cab::Errors::RecordNotFound do |e|
        BasketAPI.logger.error(e)

        error!(e, 404)
      end

      rescue_from :all do |e|
        Rollbar.error(e)

        BasketAPI.logger.error(e)
        error!(message: "Internal server error", status: 500)
      end

      helpers do
        def permitted_params
          @permitted_params ||= declared(params,
                                         include_missing: false)
        end
      end

      resource :baskets do
        desc "Create a basket" do
          params Entities::Basket::Request.documentation
          success Entities::Basket::Response
        end
        params do
          optional :basket, type: Hash do
            optional :line_items, type: Array do
              requires :product_code, type: String
              optional :quantity, type: Integer, default: 1
            end
          end
        end
        post "" do
          basket_params = declared(params, include_missing: false)
                            .fetch(:basket, {})
                            .fetch(:line_items, {})

          basket = Cab::Repositories::BasketRepository.create(basket_params)
          present basket, with: Entities::Basket::Response, status: :created
        end

        desc "Destroy a basket"
        delete ":id" do
          Cab::Repositories::BasketRepository.destroy!(params[:id])

          status :ok
        end

        desc "Retrieves a basket"
        get ":id" do
          basket = Cab::Repositories::BasketRepository.find!(params[:id])

          status :ok
          present basket, with: Entities::Basket::Response
        end

        desc "Adds a product to the basket" do
          params Entities::LineItem.documentation
          success Entities::Basket::Response
        end
        params do
          requires :line_item, type: Hash do
            requires :product_code, type: String
            optional :quantity, type: Integer, default: 1
          end
        end
        post ":id/line_items" do
          basket_id = params[:id]
          line_item_params = declared(params, include_missing: false)
                               .fetch(:line_item)

          basket = Cab::Repositories::BasketRepository.add_line_item(basket_id, line_item_params)
          present basket, with: Entities::Basket::Response
        end
      end
    end
  end
end
