require_relative './base_transaction'

module ExchangeCoinsService
  module Transactions
    class GetConferenceTransaction < BaseTransaction
      step :authorize, with: 'shared.authorize'
      step :validate, with: 'shared.dummy'
      step :get_conference, with: 'get_conference'
      step :present, with: 'shared.dummy'
    end
  end
end
