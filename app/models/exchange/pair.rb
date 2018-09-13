class Exchange::Pair
  include Mongoid::Document
  include Mongoid::Timestamps


  belongs_to :base, class_name: 'ExchangeCoin'
  belongs_to :target, class_name: 'ExchangeCoin'

  embedded_in :exchange
  embeds_many :klines, class_name: 'Exchange::Kline'

  def to_s
    [base.symbol, target.symbol].join('')
  end
end
