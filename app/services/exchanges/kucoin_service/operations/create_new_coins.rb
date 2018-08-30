require_relative './base_operation'
require 'dry-container'

module Exchanges::KucoinService
  module Operations
    class CreateNewCoins < BaseOperation
      extend Dry::Container::Mixin
      attr_reader :exchange, :coins, :new_coins

      def call(input)
        @coins, @exchange = input.values_at(:coins, :exchange)
        exchange_coins = @exchange.coins.map(&:symbol)
        @new_coins =  @coins.select { |c| !exchange_coins.include?(c) }

        create_new_exchange_coins

        # Success input
      end

      def create_new_exchange_coins
        new_coins.each do |symbol|
          coin = exchange.coins.new(
            symbol: symbol,
            currency: (Currency.where(symbol: symbol).first || nil)
          )
          coin.currency && coin.currency.update_attributes(is_active: true)
          if coin.save
            Rails.logger.info "#{@exchange.name} listed #{symbol}"
          end
        end
      end
    end
  end
end
