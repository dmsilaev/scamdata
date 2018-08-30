require 'dry/transaction/operation'

module Shared
  module Operations
    class Validate
      include Dry::Transaction::Operation

      def call(input, schema)
        result = schema.call(input)
        result.success? ? success_handler(result) : error_handler(result)
      end

      def success_handler(result)
        Right(result.output)
      end

      def error_handler(result)
        data = {
          code: :unprocessable_entity,
          messages: result.messages
        }

        Left(data)
      end
    end
  end
end
