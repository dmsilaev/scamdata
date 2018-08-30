require_relative './base_transaction'

module ExchangeCoinsService
  module Transactions
    class CreateTransaction < BaseTransaction
      step :authorize, with: 'shared.authorize'
      step :validate, with: 'shared.validate'
      step :build, with: 'build'
      step :build_conference, with: 'build_conference'
      step :subscribe_bot_to_conference, with: 'subscribe_bot_to_conference'
      step :make_reservations, with: 'make_reservations'
      step :persist, with: 'persist'
      tee :cancel_after_time_expired, with: 'cancel_after_time_expired'
      tee :send_create_notification, with: 'send_create_notification'
      tee :send_change_notification, with: 'send_change_notification'
      step :present, with: 'shared.present'
    end
  end
end
