class Exchange::Kline
  include Mongoid::Document
  include Mongoid::Timestamps

  field :interval, type: String
  field :open_price, type: Float
  field :close_price, type: Float
  field :high_price, type: Float
  field :low_price, type: Float
  field :base_asset_volume, type: Float
  field :quote_asset_volume, type: Float
  field :taker_buy_base_asset_volume, type: Float
  field :taker_buy_quote_asset_volume, type: Float

  embedded_in :pair, class_name: "Exchange::Pair"


end
