require 'dry/transaction/operation'

module Shared
  module Operations
    class Present
      include Dry::Transaction::Operation

      def call(input, klass = nil)
        result = if klass.present?
          presenter = klass.constantize
          presenter = presenter.new(input)
          presenter.call
        else
          input[:resource]
        end

        Right(result)
      end
    end
  end
end
