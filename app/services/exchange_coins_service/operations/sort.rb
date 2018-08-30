require_relative './base_operation'

module ExchangeCoinsService
  module Operations
    class Sort < BaseOperation
      attr_accessor :sort, :resources

      def call(input)
        @sort, @resources = input.values_at(:sort, :resources)
        Right input.merge(resources: sorted_resources)
      end

      def sorted_resources
        sort_by = sort[:sort_by] || :created_at
        sort_by = sort_by.to_sym

        direction = sort[:direction] || -1
        direction = direction.to_i

        resources.order("#{sort_by}": direction)
      end
    end
  end
end
