require_relative './base_transaction'

module ExchangeCoinsService
  module Transactions
    class CancelTransaction < BaseTransaction
      step :authorize, with: 'shared.authorize'
      step :validate, with: 'shared.validate'
      step :can_manage, with: 'can_manage'
      step :cancel, with: 'cancel'
      tee :send_cancel_notification, with: 'send_cancel_notification'
      step :present, with: 'shared.present'
    end
  end
end
