module ExchangeCoinsService
  module Utils
    module Reservations
      extend self

      def build(attributes)
        reservation_attributes = attributes.tap do |params|
          hotel_id = params.dig(:hotel, :id)
          hotel = Hotel.find(hotel_id)
          params[:hotel] = hotel

          check_in = params.delete(:check_in)
          @check_in = check_in_time(check_in, hotel)
          params[:check_in] = @check_in

          check_out = params.delete(:check_out)
          @check_out = check_out_time(check_out, hotel)
          params[:check_out] = @check_out

          slots_attributes = params.delete(:slots)
          params[:slots_attributes] = map_slots(slots_attributes)

          price = calc_price(slots_attributes)
          params[:price] = price
        end

        Reservation.new(reservation_attributes)
      end

      def update(reservation, attributes)
        reservation_attributes = attributes.tap do |params|
          hotel_id = params.dig(:hotel, :id)
          hotel = Hotel.find(hotel_id)
          params[:hotel] = hotel

          check_in = params.delete(:check_in)
          @check_in = check_in_time(check_in, hotel)
          params[:check_in] = @check_in

          check_out = params.delete(:check_out)
          @check_out = check_out_time(check_out, hotel)
          params[:check_out] = @check_out

          slots_attributes = params.delete(:slots)
          params[:slots_attributes] = map_slots(slots_attributes)

          price = calc_price(slots_attributes)
          params[:price] = price
        end

        reservation.update(reservation_attributes)

        reservation
      end

      def check_in_time(check_in_date, hotel)
        time = hotel.settings.check_in_time
        value = [time, check_in_date.to_s].join(" ")

        Time.zone.parse(value)
      end

      def check_out_time(check_out_date, hotel)
        time = hotel.settings.check_out_time
        value = [time, check_out_date.to_s].join(" ")

        Time.zone.parse(value)
      end

      def map_slots(slots_attributes)
        slots_attributes.map do |slot_attributes|
          map_slot(slot_attributes)
        end
      end

      def map_slot(slot_attributes)
        slot_attributes.tap do |params|
          tariff_id = params.dig(:tariff, :id)
          tariff = Tariff.find(tariff_id)
          params[:tariff] = tariff

          room_type = tariff.room_type
          room = room_type.rooms.not_archived.sample
          params[:room] = room
          params.delete(:room_type)

          params[:multi_seat] = room_type.multi_seat

          policies = params.delete(:policies)
          params[:policies_attributes] = map_policies(tariff, policies)

          price = calc_slot_price(policies)
          params[:price] = price
        end
      end

      def map_policies(tariff, policies)
        policies.map { |policy| map_policy(tariff, policy) }
      end

      def map_policy(tariff, policy)
        policy.tap do |params|
          type = params[:rate][:type]
          rate = tariff.rates.find_by(type: type)
          params[:rate] = convert_rate(rate)

          params[:price] = calc_policy_price(params)
        end
      end

      def convert_rate(rate)
        rate.attributes
          .with_indifferent_access
          .without("_id", "rules", "inc_number")
          .tap do |params|
            params["rules"] = convert_rules(rate)
            params["periods"] = convert_periods(rate)
          end
      end

      def convert_rules(rate)
        rate.rules
          .where('$and' => [
            {:date.gte => @check_in},
            {:date.lt => @check_out}
          ])
          .map { |rule| convert_rule(rule) }
      end

      def convert_rule(rule)
        rule
          .attributes
          .without("_id")
          .with_indifferent_access
      end

      def convert_periods(rate)
        periods = []

        rules = rate.rules.seasonal
          .where('$or': [
            { start_date: { '$lte': @check_in }, end_date: { '$gt': @check_in } },
            { start_date: { '$gte': @check_in }, end_date: { '$lte': @check_out } },
            { start_date: { '$lt': @check_out }, end_date: { '$gte': @check_out } },
          ])
          .order(start_date: 1)
          .map { |rule| map_period(rule) }

        rate_period = {
          start_date: @check_in.to_date,
          end_date: @check_out.to_date,
          price: rate.price
        }

        while rate_period[:start_date] < rate_period[:end_date]
          rate_period, ranges = divide_period_by_rule(rate_period, rules.shift)
          periods.concat(ranges)
        end

        periods
      end

      def divide_period_by_rule(period, rule)
        ranges = []

        intersection = if rule.present?
          (period[:start_date].to_date .. period[:end_date].to_date).to_a \
          & (rule[:start_date].to_date .. rule[:end_date].to_date).to_a
        else
          []
        end

        if intersection.empty?
          ranges << period.deep_dup

          period = period.tap do |params|
            params[:start_date] = params[:end_date]
          end

          return [period, ranges]
        end

        ranges << Hash(
          start_date: period[:start_date],
          end_date: intersection.first,
          price: period[:price]
        ) if period[:start_date] < intersection.first

        ranges << Hash(
          start_date: intersection.first,
          end_date: intersection.last,
          price: rule[:price]
        )

        period = Hash(
          start_date: intersection.last,
          end_date: period[:end_date],
          price: period[:price]
        )

        [period, ranges]
      end

      def map_periods(rate)
        rate.rules
          .seasonal
          .map { |rule| map_period(rule) }
      end

      def map_period(rule)
        rule
          .attributes
          .with_indifferent_access
          .without("_id")
      end

      def calc_slot_price(policies)
        policies.reduce(0) do |sum, policy|
          sum += policy[:price]
        end
      end

      def calc_policy_price(policy)
        count = policy[:count]
        price_per_night = policy.dig(:rate, :price)

        price = policy[:rate][:periods].reduce(0) do |sum, period|
          count = period[:end_date].mjd - period[:start_date].mjd
          sum += count * period[:price]
        end

        rules_prices = policy[:rate][:rules].map { |rule| rule[:price] }

        price - (rules_prices.count * price_per_night) + rules_prices.sum
      end

      def calc_price(slots_attributes)
        slots_attributes.reduce(0) do |sum, slot|
          sum += slot[:price]
        end
      end
    end
  end
end
