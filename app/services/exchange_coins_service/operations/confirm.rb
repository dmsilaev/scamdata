module ExchangeCoinsService
  module Operations
    class Confirm < BaseOperation
      def call(input)
        order = input[:resource]
        reservations, error = order_confirm(order)

        if error.nil?
          order.integration_modify
          order.confirm!
          Right(input)
        else
          clean_reservations(reservations)
          Left(error)
        end
      rescue => e
        clean_reservations(reservations)
        raise e
      end

      def order_confirm(order)
        error = nil
        reservations = []

        order.reservations.booked.each do |reservation|
          result = reservation_confirm(reservation)

          if result.success?
            reservations << result.value
          else
            error = result.value
            break
          end
        end

        return [reservations, error]
      end

      def reservation_confirm(reservation)
        reservation_service.confirm(
          resource: reservation
        )
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
