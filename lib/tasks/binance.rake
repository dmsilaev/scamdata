require 'binance'
require 'faye/websocket'
require 'eventmachine'
require 'em-http-request'

namespace :binance do
  desc "Import price-list from SOGAZ_1C"
  task get_amount: :environment do
    @binance = Exchange.find_by(name: 'binance')
    client = Cryptoexchange::Client.new
    pairs = client.pairs('binance')
    run_websocket_client(pairs)
  end
end
#
def redis
  @redis ||= Redis.new
end

def run_websocket_client(pairs)
  pairs = pairs.map {|pair| [pair.base,pair.target].join('') }

  client = Binance::Client::WebSocket.new
  concurrency = 100

  EM.run do
    EM::Iterator.new(pairs, concurrency).each do |pair, iter|
      messageHandler = proc do |e|
        data = JSON.parse(e.data)
        if data['k']['x']
          old_data = redis.get("3m_amount_#{pair}").to_f

          redis.set("3m_amount_#{pair}", data['k']["q"])
          next if old_data == 0
          next if data['k']["q"].to_f == 0
          otm = (old_data/data['k']['q'].to_f)

          puts "#{pair} change  amount x#{otm} in last 3 minute"
        end
      end
    #
    #   puts data['k']['v']
        openHandler   = proc { puts "connected#{pair}" }
        errorHandler   = proc { |e| puts e }
        closeHandler   = proc { puts 'closed' }

    # # Bundle our event handlers into Hash
        methods = { open: openHandler, message: messageHandler, error: errorHandler, close: closeHandler }        # Pass a symbol and event handler Hash to connect and process events
        client.kline symbol: pair, interval: '1m', methods: methods
    # }
    #   proc {
    #     p 'All done!'
    #     EM.stop
    #   })
    end
  end
end

