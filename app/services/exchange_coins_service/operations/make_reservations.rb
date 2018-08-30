moduleExchangeCoinsService
  module Operations
    class MakeReservations < BaseOperation
      attr_reader :order, :attributes

      def call(input)
        order, attributes = input.values_at(:resource, :attributes)
        reservations, error = make_reservations(attributes)

        if error.nil?
          order.reservations.concat(reservations)
          order.price = calc_price(order)
          order.book unless order.booked?

          Right(input)
        else
          clean_reservations(reservations)
          Left(error)
        end
      rescue => e
        clean_reservations(reservations)
        raise e
      end

      def make_reservations(attributes)
        error = nil
        reservations = []

        attributes[:reservations].each do |reservation_attributes|
          result = reservation_service.create(
            attributes: reservation_attributes
          )

          if result.success?
            reservations.push(result.value)
          else
            error = result.value
            break
          end
        end

        return [reservations, error]
      end

      def clean_reservations(reservations)
        reservations ||= []
        reservations.each(&:destroy!)
      end

      def calc_price(order)
        order.reservations
          .select { |reservation| !reservation.cancelled? }
          .reduce(0) do |sum, reservation|
            sum += reservation.price
          end
      end
    end
  end
end
