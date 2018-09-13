EXCHANGES=['binance']

namespace :init  do
  task update_exchanges: :environment do
    update_exchanges
  end

  task load_currencies: :environment do
    puts "load coinmarcetcap currencies"
    service = CMCService::Service.new
    service.update_currencies()
    puts "currencies count #{Currency.count}"
  end

  def update_exchanges
    EXCHANGES.each do |exchange_name|
      puts "update #{exchange_name}"
      exchange = Exchange.find_or_initialize_by(name: exchange_name)
      attributes = send("#{exchange_name}_attributes")
      ap attributes
      exchange.update_attributes(attributes)
    end
  end


  private

  def binance_attributes
    {
      name: 'binance',
      url: 'http://binance.com',
      connector: {
        api_url: 'https://api.binance.com',
        api_documentation_url: 'https://github.com/binance-exchange/binance-official-api-docs/',
        connector_suffix: 'binance'
      }
    }
  end
end
