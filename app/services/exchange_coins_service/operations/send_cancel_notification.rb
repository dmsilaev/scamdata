module ExchangeCoinsService
  module Operations
    class SendCancelNotification < BaseOperation
      includeExchangeCoinsService::Jobs::Import['send_cancel_notification']

      def call(input)
        order = input[:resource]
        send_cancel_notification.perform_later(order: order)
      end
    end
  end
end
