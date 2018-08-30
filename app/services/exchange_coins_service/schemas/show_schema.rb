module ExchangeCoinsService
  module Schemas
    ShowSchema = Dry::Validation.Form(BaseForm) do
      required(:resource, Types::Strict::ExchangeCoin).filled
    end
  end
end
