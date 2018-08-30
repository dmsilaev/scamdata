require_relative './base_transaction'

module Exchanges::KucoinService
  module Transactions
    class UpdateExchangeCoinsTransaction < BaseTransaction
      step :get_coins, with: 'get_coins'
      tee :create_new_coins, with: 'create_new_coins'
    end
  end
end
