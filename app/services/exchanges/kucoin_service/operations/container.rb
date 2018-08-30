require 'dry-container'

module Exchanges::KucoinService
  module Operations
    class Container
      extend Dry::Container::Mixin

      register('get_coins') { GetCoins.new }
      register('create_new_coins') { CreateNewCoins.new }
    end
  end
end
