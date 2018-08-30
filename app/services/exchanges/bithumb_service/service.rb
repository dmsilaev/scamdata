module Exchanges::BithumbService
  class Service < BaseService
    def self.transactions
      {
        update_exchange_coins: Transactions::UpdateExchangeCoinsTransaction
      }
    end

  end
end
