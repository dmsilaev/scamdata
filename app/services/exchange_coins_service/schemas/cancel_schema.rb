module ExchangeCoinsService
  module Schemas
    CancelSchema = Dry::Validation.Form(BaseForm) do
      required(:resource, Types::Strict::ExchangeCoin).filled
    end
  end
end
