moduleExchangeCoinsService
  module Operations
    class GetConference < BaseOperation
      def call(input)
        order = input[:resource]
        Right(order.conference)
      end
    end
  end
end
