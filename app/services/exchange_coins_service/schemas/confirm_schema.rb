module ExchangeCoinsService
  module Schemas
    ConfirmSchema = Dry::Validation.Form(BaseForm) do
      required(:resource, Types::Strict::ExchangeCoin).filled
    end
  end
end
