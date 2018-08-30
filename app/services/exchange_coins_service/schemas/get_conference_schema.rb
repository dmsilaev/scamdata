module ExchangeCoinsService
  module Schemas
    GetConferenceSchema = Dry::Validation.Form(BaseForm) do
      required(:resource, Types::Strict::ExchangeCoin).filled
    end
  end
end
