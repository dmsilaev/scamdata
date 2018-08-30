class Currency
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :symbol, type: String
  field :id, type: String

  field :is_active, type: Boolean, default: false


  ## Scopes
  scope :active, ->() {
    where(is_active: true) }

  embeds_one :cmc_info

  has_many :exchange_coins
end
