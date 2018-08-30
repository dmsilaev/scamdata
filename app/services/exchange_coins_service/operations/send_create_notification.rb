module ExchangeCoinsService
  module Operations
    class SendCreateNotification < BaseOperation
      includeExchangeCoinsService::Jobs::Import['send_create_notification']

      def call(input)
        order = input[:resource]
        send_create_notification.perform_later(order: order)
      end
    end
  end
end
