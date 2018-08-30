module CMCService
  class Service < BaseService
    def self.transactions
      {
        update_currencies: Transactions::UpdateCurrenciesTransaction
      }
    end
  end
end
