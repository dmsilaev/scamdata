module ExchangeCoinsService
  module Operations
    class SendConfirmNotification < BaseOperation
      includeExchangeCoinsService::Jobs::Import['send_confirm_notification']

      def call(input)
        order = input[:resource]
        send_confirm_notification.perform_later(order: order)
      end
    end
  end
end
