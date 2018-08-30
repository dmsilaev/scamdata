module ExchangeCoinsService
  module Operations
    class Cancel < BaseOperation
      def call(input)
        order = input[:resource]
        reservations, error = order_cancel(order)

        if error.nil?
          order.integration_cancel
          order.cancel!
          Right(input)
        else
          clean_reservations(reservations)
          Left(error)
        end
      rescue => e
        clean_reservations(reservations)
        raise e
      end

      def order_cancel(order)
        error = nil
        reservations = []

        order
          .reservations
          .not_cancelled
          .each do |reservation|
            result = reservation_cancel(reservation)

            if result.success?
              reservations << result.value
            else
              error = result.value
              break
            end
          end

        return [reservations, error]
      end

      def reservation_cancel(reservation)
        user = reservation.order.source._type == 'InsuranceSource' ? \
          reservation.order.source.source : reservation.order.source.manager
        RequestLocals.store[:current_user] = user

        options = {
          resource: reservation
        }

        trns_args = {
          send_change_notification: -> input { Right(input) }
        }

        step_args = {}

        reservation_service.cancel(options, step_args, trns_args)
      end

      def clean_reservations(reservations)
        reservations ||= []
        reservations.each do |reservation|
          reservation.set(aasm_state: :booked)
        end
      end
    end
  end
end
