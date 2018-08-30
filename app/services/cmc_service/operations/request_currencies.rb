require 'dry/transaction/operation'
require_relative './base_operation'

module CMCService
  module Operations
    class RequestCurrencies < BaseOperation
      attr_reader :response

      def call(input)
        @response = RestClient.get('https://api.coinmarketcap.com/v2/listings/')
        Success input.merge(currencies: JSON.parse(response)['data'])
      end

    end
  end
end
