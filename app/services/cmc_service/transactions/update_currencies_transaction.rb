require_relative './base_transaction'

module CMCService
  module Transactions
    class UpdateCurrenciesTransaction < BaseTransaction
      step :request_currencies, with: 'request_currencies'
      step :update_currencies, with: 'update_currencies'
    end
  end
end
