require 'dry/transaction/operation'

module Exchanges::BittrexService
  module Operations
    class OperationError < StandardError; end

    class BaseOperation
      def self.inherited(klass)
        klass.send :include, Dry::Transaction::Operation
      end

      def call(input)
        # Provide custom behaviour for calling operation
        super(input)
      end
    end
  end
end
