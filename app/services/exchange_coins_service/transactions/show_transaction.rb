require_relative './base_transaction'

module ExchangeCoinsService
  module Transactions
    class ShowTransaction < BaseTransaction
      step :authorize, with: 'shared.authorize'
      step :validate, with: 'shared.validate'
      step :scope, with: 'scope'
      step :present, with: 'shared.present'
    end
  end
end
