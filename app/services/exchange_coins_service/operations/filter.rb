require_relative './base_operation'

module ExchangeCoinsService
  module Operations
    class Filter < BaseOperation
      attr_accessor :filter, :resources

      def call(input)
        @filter, @resources = input.values_at(:filter, :resources)
        Right input.merge(resources: filtered_resources)
      end

      def filtered_resources
        filters = []

        filters << check_in_filter
        filters << check_out_filter

        filters << manager_filter
        filters << managers_filter

        filters << status_filter
        # filters << statuses_filter

        filters << source_filter

        filters
          .compact
          .inject(resources) { |o, op| o.send(*op) }
      end

      def check_in_filter
        return nil unless filter[:check_in].present?

        args = { check_in: {'$gte': filter[:check_in]} }

        ['where', args]
      end

      def check_out_filter
        return nil unless filter[:check_out].present?

        args = { check_out: {'$lte': filter[:check_out]} }

        ['where', args]
      end

      def hotel_filter
        return nil unless filter[:hotel].present?

        hotel_id = filter[:hotel]

        order_ids = Reservation
          .where(hotel_id: { '$eq': BSON::ObjectId(hotel_id) })
          .pluck(:order_id)
          .compact

        args = { _id: { '$in': order_ids }}

        ['where', args]
      end

      def hotels_filter
        return nil unless filter[:hotels].present?

        hotel_ids = filter[:hotels].pluck(:id)

        order_ids = Reservation
          .where(hotel_id: { '$in': hotel_ids })
          .pluck(:order_id)
          .compact

        args = { _id: { '$in': order_ids }}

        ['where', args]
      end

      def manager_filter
        return nil unless filter[:manager].present?

        manager_id = filter[:manager]
        source_ids = ExchangeCoinsServiceSource
          .where(manager_id: BSON::ObjectId(manager_id))
          .pluck(:id)
          .compact
        args = { source: { '$in': source_ids } }

        ['where', args]
      end

      def managers_filter
        return nil unless filter[:managers].present?

        manager_ids = filter[:managers].pluck(:id).map{ |id| BSON::ObjectId(id) }
        source_ids = ExchangeCoinsServiceSource
          .where(manager_id: { '$in': manager_ids })
          .pluck(:id)
          .compact

        args = { source: { '$in': source_ids } }

        ['where', args]
      end

      def status_filter
        return nil unless filter[:status].present?

        status = filter[:status].to_sym
        args = { aasm_state: { '$eq': status } }

        ['where', args]
      end

      def statuses_filter
        return nil unless filter[:statuses].present?

        statuses = filter[:statuses] || []

        statuses = statuses
          .select { |k, v| v.to_s == "true" }
          .keys
          .map(&:to_sym)

        return nil if statuses.empty?

        args = { aasm_state: { '$in': statuses } }

        ['where', args]
      end

      def source_filter
        return nil unless filter[:type].present?

        type_id = BSON::ObjectId(filter[:type])
        source_ids = ExchangeCoinsServiceSource
          .where(source_id: type_id)
          .pluck(:id)
          .compact

        args = { source: { '$in': source_ids } }

        ['where', args]
      end
    end
  end
end
