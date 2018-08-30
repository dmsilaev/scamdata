module CMCService
  module Operations
    class UpdateCurrencies < BaseOperation

      def call(input)
        currencies = input[:currencies]
        currencies.map do |currency|
          cur = Currency.where(name: currency['name'], symbol: currency['symbol']).first_or_create
        end
        Success(input)
      end
    end
  end
end
