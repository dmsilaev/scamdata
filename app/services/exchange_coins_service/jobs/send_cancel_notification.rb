module ExchangeCoins
  module Jobs
    class SendCancelNotification < ApplicationJob
      attr_reader :order

      def perform(input)
        @order = input[:order]
        send_notification
      end

      def send_notification
        ExchangeCoinsMailer
          .with(context)
          .send_cancel_notification
          .deliver_now
      end

      def context
        ExchangeCoinssPresenter::EmailCancelView.new(resource: order).call
      end
    end
  end
end
