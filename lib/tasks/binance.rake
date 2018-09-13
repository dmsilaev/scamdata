require 'binance'
require 'faye/websocket'
require 'eventmachine'
require 'em-http-request'

namespace :binance do
  desc "Import price-list from SOGAZ_1C"
  task get_amount: :environment do
    @binance = Exchange.find_by(name: 'binance')
    run_websocket_client
  end

  desc "Update pairs"
  task update_pairs: :environment do
    @binance = Exchange.find_by(name: 'binance')
    client = Cryptoexchange::Client.new
    pairs = client.pairs('binance')
    @binance.pairs = []

    pairs.each do |pair|
      base = @binance.coins.where(symbol: pair.base).first
      target = @binance.coins.where(symbol: pair.target).first
      next if base.nil? || target.nil?
      @binance.pairs << Exchange::Pair.new(base_id: base.id, target_id: target.id)
    end
    @binance.save
  end
end
#
def redis
  @redis ||= Redis.new
end

def run_websocket_client
  client = Binance::Client::WebSocket.new
  concurrency = 100
  pairs = @binance.pairs
  EM.run do
    EM::Iterator.new(pairs, concurrency).each do |pair, iter|
      symbol = pair.to_s

      messageHandler = proc do |e|
        data = JSON.parse(e.data)
        kline_data = data['k']

        kline = pair.klines.find_or_initialize_by(interval: kline_data['i'])
        kline.update_attributes(
          interval: kline_data['i'],
          open_price:  kline_data['o'],
          close_price:  kline_data['c'],
          high_price:  kline_data['h'],
          low_price:  kline_data['l'],
          base_asset_volume:  kline_data['v'],
          quote_asset_volume:  kline_data['q'],
          taker_buy_base_asset_volume:  kline_data['V'],
          taker_buy_quote_asset_volume:  kline_data['Q']
        )
        ap kline
      end
    #
    #   puts data['k']['v']
        openHandler   = proc { puts "connected #{pair}" }
        errorHandler   = proc { |e| puts e }
        closeHandler   = proc { puts 'closed' }

    # # Bundle our event handlers into Hash
        methods = { open: openHandler, message: messageHandler, error: errorHandler, close: closeHandler }        # Pass a symbol and event handler Hash to connect and process events

        client.kline symbol: symbol, interval: '1m', methods: methods
        client.kline symbol: symbol, interval: '1h', methods: methods
        client.kline symbol: symbol, interval: '24h', methods: methods
    end
  end
end

