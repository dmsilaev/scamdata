module ExchangeCoinsService
  module Schemas
    IndexSchema = Dry::Validation.Form(BaseForm) do
      required(:resource, Types::Strict::ExchangeCoin).filled
    end
  end
end
