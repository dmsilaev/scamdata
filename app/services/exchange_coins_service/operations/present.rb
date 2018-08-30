require_relative './base_operation'

module ExchangeCoinsService
  module Operations
    class Present < BaseOperation
      def call(input)
        resources= input[:resources]

        coins = resources.includes(:exchange_coins).map { |coin| map_coin(coin) }

        Success(coins: coins)
      end

      def map_coin(coin)

        Hash(
          id: coin.id.to_s,
          created_at: coin.created_at,
          updated_at: coin.updated_at,
          name: coin.name,
          exchanges: coin.exchange_coins.map(&:exchange),
          symbol: coin.symbol
        )
      end

      def meta
      end

      def map_contract(order)
        order.contract.attributes
          .slice("number", "begin_date", "end_date", "price_prefix")
      end

      def get_reservations(order)
        ops = []
        ops << ['reservations']
        ops << ['not_cancelled'] unless order.cancelled?
        ops << ['includes', :slots, :hotel]
        ops << ['entries']

        ops.inject(order) { |o, op| o.send(*op) }
      end

      def map_price(reservations)
        amount = reservations
          .inject(0) { |sum, reservation| sum + reservation.price }

        Hash(amount: amount, currency: 'RUB')
      end

      def map_creator(creator)
        options = {
          serializer: CreatorSerializer,
          include: [],
          root: :creator
        }

        data = ActiveModelSerializers::SerializableResource.new(
          creator, options
        ).as_json

        data[:creator]
      end

      def map_travellers(travellers)
        travellers.map { |traveller| map_traveller(traveller) }
      end

      def map_traveller(traveller)
        Hash(
          first_name: traveller.first_name,
          last_name: traveller.last_name,
          middle_name: traveller.middle_name,
          document: map_document(traveller.document)
        )
      end

      def map_document(document)
        Hash(
          number: document.number
        )
      end

      def map_hotels(reservations)
        reservations
          .map { |reservation| reservation.hotel }
          .uniq { |hotel| hotel.id }
          .map { |hotel| map_hotel(hotel) }
      end

      def map_hotel(hotel)
        Hash(name: hotel.name)
      end

      def get_travellers_count(reservations)
        reservations.reduce(0) do |sum, reservation|
          count = reservation.slots
            .not_cancelled
            .count

          sum += count
        end
      end

      def get_draft_state(reservations)
        reservations.any? do |reservation|
          reservation.slots.non_cash.any? do |slot|
            !slot.has_travellers?
          end
        end
      end
    end
  end
end
