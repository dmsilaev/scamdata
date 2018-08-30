module Swagger::ApiDocs
  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    swagger_root do
      key :swagger, '2.0'
      info do
        key :version, '1.0.0'
        key :title, 'API INS App'
        key :description, 'API INS App'
        contact name: 'overteam'
        # license name: 'MIT'
      end
      key :basePath, '/api'
      key :consumes, ['application/json']
      key :produces, ['application/json']

      security_definition :api_key do
        key :type, :apiKey
        key :name, :api_key
        key :in, :query
      end

      # extend Swagger::Parameters
    end

    SWAGGERED_CLASSES = [
      Platform::IntegrationsController,
      # Order,
      # Platform::OrdersController,
      self,
    ].freeze
  end

  def root_json
    Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
  end
end
