class Exchange::Connector
  include Mongoid::Document
  include Mongoid::Timestamps

  field :api_url, type: String
  field :api_documentation_url, type: String
  field :credentials, type: Hash
  field :connector_suffix, type: String

  embedded_in :exchange

  def service
    service_class.new
  end

  def service_class
    "exchanges/#{connector_suffix}_service/service".camelize.constantize
  end
end
