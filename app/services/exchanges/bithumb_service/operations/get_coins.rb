require_relative './base_operation'
require 'dry-container'

module Exchanges::BithumbService
  module Operations
    class GetCoins < BaseOperation
      extend Dry::Container::Mixin

      def call(input)
        client = Cryptoexchange::Client.new
        pairs = client.pairs('binance')
        coins = pairs.map(&:base).uniq

        Success input.merge(pairs: pairs, coins: coins)
      end

    end
  end
end
