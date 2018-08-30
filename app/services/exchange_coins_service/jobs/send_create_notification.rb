module ExchangeCoins
  module Jobs
    class SendCreateNotification < ApplicationJob
      attr_reader :order

      def perform(input)
        @order = input[:order]
        send_notification if order_created?
      end

      def send_notification
        ExchangeCoinsMailer
          .with(context)
          .send_create_notification
          .deliver_now
      end

      def context
        ExchangeCoinssPresenter::EmailCreateView.new(resource: order).call
      end

      def order_created?
        order.reservations.all?(&:booked?)
      end
    end
  end
end
