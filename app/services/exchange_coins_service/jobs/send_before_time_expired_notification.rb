module ExchangeCoins
  module Jobs
    class SendBeforeTimeExpiredNotification < ApplicationJob
      attr_reader :order

      def perform(input)
        @order = input[:order]
        send_notification if order.booked?
      end

      def send_notification
        ExchangeCoinsMailer
          .with(context)
          .send_before_expired_notification
          .deliver_now
      end

      def context
        options = {
          resource: order,
          to_insurance: true
        }

        ExchangeCoinssPresenter::EmailBeforeExpiredView.new(options).call
      end
    end
  end
end
