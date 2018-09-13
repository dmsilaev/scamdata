class Exchange
  include Mongoid::Document

  field :name, type: String
  field :url, type: String

  ## Relations
  has_many :coins, class_name: 'ExchangeCoin'

  embeds_many :pairs, class_name: 'Exchange::Pair'
  embeds_one :connector, class_name: 'Exchange::Connector'

  validates :name, uniqueness: true
  validates :name, presence: true

end
