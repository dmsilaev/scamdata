require_relative './base_transaction'

module ExchangeCoinsService
  module Transactions
    class IndexTransaction < BaseTransaction
      # step :authorize, with: 'shared.dummy'
      # step :validate, with: 'shared.dummy'
      step :scope, with: 'scope'
      # step :filter, with: 'filter'
      # step :sort, with: 'sort'
      step :present, with: 'present'
    end
  end
end
