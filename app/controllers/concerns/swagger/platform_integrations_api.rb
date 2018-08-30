module Swagger::PlatformIntegrationsApi

  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    include Swagger::ErrorSchema

    swagger_path '/integrations/' do

      operation :post do
        key :description, 'Create integration request'
        key :produces, [
          'application/json'
        ]

        security do
          key :api_key, []
        end

        parameter do
          key :name, :body
          key :in, :query
          key :description, 'XML Request'
          key :required, true
          key :type, :string_base64_encoded
        end

        response 200 do
          key :description, 'successfully'
          schema do
          end
        end

        extend Swagger::ErrorResponses::AuthenticationError

      end

    end
  end

end
