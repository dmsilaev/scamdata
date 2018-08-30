  module ExchangeCoinsService
  module Operations
    class SendChangeNotification < BaseOperation
      includeExchangeCoinsService::Jobs::Import['send_change_notification']

      def call(input)
        order = input[:resource]
        send_change_notification.perform_later(order: order)
      end
    end
  end
end
