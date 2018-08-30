require_relative './base_transaction'

module ExchangeCoinsService
  module Transactions
    class ConfirmTransaction < BaseTransaction
      step :authorize, with: 'shared.authorize'
      step :validate, with: 'shared.validate'
      step :can_manage, with: 'can_manage'
      step :confirm, with: 'confirm'
      tee :send_confirm_notification, with: 'send_confirm_notification'
      step :present, with: 'shared.present'
    end
  end
end
