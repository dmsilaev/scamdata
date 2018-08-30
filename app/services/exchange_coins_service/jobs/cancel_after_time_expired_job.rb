module ExchangeCoins
  module Jobs
    class CancelAfterTimeExpiredJob < ApplicationJob
      attr_reader :order

      def perform(input)
        @order = input[:order]
        cancel_order if order.created? || order.booked?
      end

      def cancel_order
        user =  order.source._type == 'InsuranceSource' ? order.source.source : order.source.manager
        RequestLocals.store[:current_user] = user

        input = { resource: order }
        step_args = {}
        trns_args = {}

        order_service.cancel(input, step_args, trns_args)
      end

      def order_service
        @order_service = ExchangeCoins::Service.new
      end
    end
  end
end
