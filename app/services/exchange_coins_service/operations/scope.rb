module ExchangeCoinsService
  module Operations
    class Scope < BaseOperation
      def call(input)
        Success input.merge(resources: resources)
      end

      def resources
        Currency.where(is_active: true)
      end
    end
  end
end
