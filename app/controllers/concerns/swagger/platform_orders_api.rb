module Swagger::PlatformOrdersApi

  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    include Swagger::ErrorSchema

    swagger_path '/orders/{id}' do

      parameter :order_id do
        key :name, :id
      end

      operation :get do
        key :description, 'Finds the specified order'
        key :operationId, :find_order_by_id

        response 200 do
          key :description, 'Order specified by its ID'
          schema do
            key :'$ref', :OrderOutput
          end
        end

        extend Swagger::ErrorResponses::NotFoundError

      end

    end
  end

end
