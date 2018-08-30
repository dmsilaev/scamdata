module ExchangeCoinsService
  module Operations
    class CanManage < BaseOperation
      def call(input)
        order = input[:resource]
        error = can_confirm(order)

        if error.nil?
          Right(input)
        else
          error_handler(error)
        end
      rescue => e
        raise e
      end

      def can_confirm(order)
        error = nil

        can_confirm = if current_user.requested_by?(:insurance)
          order.source.source == current_user
        else
          order.source.source == current_user.hotel
        end

        order_source = current_user.requested_by?(:insurance) ? 'санаторием' : 'страховой команией'

        error = "Доступ запрещен. Вы пытаетесь подтвердить заявку, созданную #{order_source}" if !can_confirm

        return error
      end

      def error_handler(messages)
        Left(code: :unprocessable_entity, messages: messages)
      end
    end
  end
end
