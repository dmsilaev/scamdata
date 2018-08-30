class Exchange
  include Mongoid::Document

  field :name, type: String
  field :api_url, type: String
  field :api_documentation_url, type: String
  field :code_name

  ## Relations
  has_many :coins, class_name: 'ExchangeCoin'

  validates :name, uniqueness: true

end
