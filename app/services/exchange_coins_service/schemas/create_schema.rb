module ExchangeCoinsService
  module Schemas
    CreateSchema = Dry::Validation.Form(BaseForm) do
      required(:attributes, Types::Coercible::Hash).schema(ExchangeCoinSchema)
    end
  end
end
