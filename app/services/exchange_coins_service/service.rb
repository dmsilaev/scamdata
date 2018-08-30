module ExchangeCoinsService
  class Service < BaseService
    def self.transactions
      {
        index: Transactions::IndexTransaction,
        show: Transactions::ShowTransaction,
        create: Transactions::CreateTransaction,
        confirm: Transactions::ConfirmTransaction,
        cancel: Transactions::CancelTransaction,
        conference: Transactions::GetConferenceTransaction,
      }
    end

    def with_step_args(name = nil)
      Hash(authorize: [name, ExchangeCoin])
    end
  end
end
