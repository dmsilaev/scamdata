module ExchangeCoins
  module Jobs
    class SendChangeNotification < ApplicationJob
      attr_reader :order

      def perform(input)
        @order = input[:order]
        send_notification if order_updated?
      end

      def send_notification
        ExchangeCoinsMailer
          .with(context)
          .send_change_notification
          .deliver_now
      end

      def context
        ExchangeCoinssPresenter::EmailChangeView.new(resource: order).call
      end

      def order_updated?
        order.reservations.any?(&:confirmed?) || order.reservations.any?(&:cancelled?)
      end
    end
  end
end
