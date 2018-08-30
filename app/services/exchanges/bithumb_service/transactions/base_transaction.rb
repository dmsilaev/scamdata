require 'dry/transaction'
require_relative '../operations/container'

module Exchanges::BithumbService
  module Transactions
    class BaseTransaction
      def self.inherited(klass)
        klass.send :include, Dry::Transaction(container: Operations::Container)
      end

      def call(input)
        # Provide custom behaviour for calling transactions
        super(input)
      end
    end
  end
end
