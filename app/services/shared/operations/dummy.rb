require 'dry/transaction/operation'

module Shared
  module Operations
    class Dummy
      include Dry::Transaction::Operation

      def call(input, *args)
        Right(input)
      end
    end
  end
end
