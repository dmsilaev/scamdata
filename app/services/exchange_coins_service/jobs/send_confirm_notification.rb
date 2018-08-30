module ExchangeCoins
  module Jobs
    class SendConfirmNotification < ApplicationJob
      attr_reader :order

      def perform(input)
        @order = input[:order]
        send_notification
      end

      def send_notification
        ExchangeCoinsMailer
          .with(context)
          .send_confirm_notification
          .deliver_now
      end

      def context
        ExchangeCoinssPresenter::EmailConfirmView.new(resource: order).call
      end
    end
  end
end
