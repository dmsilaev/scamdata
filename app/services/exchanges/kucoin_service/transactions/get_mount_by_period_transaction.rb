require_relative './base_transaction'

module Exchanges::KucoinService
  module Transactions
    class UpdateExchangeCoinsTransaction < BaseTransaction
      step :get_amount_by_period, with: 'get_amount_by_period'
    end
  end
end
