require 'dry-container'

module CMCService
  module Operations
    class Container
      extend Dry::Container::Mixin

      register('request_currencies') { RequestCurrencies.new }
      register('update_currencies') { UpdateCurrencies.new }
    end
  end
end
