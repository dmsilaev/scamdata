moduleExchangeCoinsService
  module Operations
    class Persist < BaseOperation
      def call(input)
        order = input[:resource]

        order.integration_modify if order.persisted?
        order.save ? Right(input) : error_handler(order)
      end

      def success_handler(result)
        Right(result.output)
      end

      def error_handler(order)
        data = {
          code: :unprocessable_entity,
          messages: order.errors.messages
        }

        Left(data)
      end
    end
  end
end
