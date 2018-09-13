require 'dry-container'

module UpdateExchangeCoins
  extend self
  attr_reader :exchanges


  def call(*args)
    Rails.logger.level = Logger::INFO
    @exchanges = Exchange.all

    cmc_service.send('update_currencies',{})
    300.times do |i|
      Rails.logger.info "update ##{i}/300"
      exchanges.each { |e| exchange_service(e).send('update_exchange_coins', { exchange: e }) }
      sleep 60
    end
  end

  def cmc_service
    CMCService::Service.new
  end

  def exchange_service(exchange)
    service_class(exchange).new
  end

  def service_class(exchange)
    "exchanges/#{exchange.name}_service/service".camelize.constantize
  end
end
