class ExchangeCoin
  include Mongoid::Document
  include Mongoid::Timestamps

  field :symbol, type: String
  field :last_amount_candle, type: Float
  field :last_amount_candle_time, type: DateTime

  belongs_to :exchange
  belongs_to :currency

end
