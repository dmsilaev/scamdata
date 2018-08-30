class CoinsController < ApiController
  before_action :set_result

  def index
    json_response @result
  end


  private

  def service
    @service ||= ExchangeCoinsService::Service.new
  end

  def set_result
    input = {
      action: params[:action],
      resource: resource,
      attributes: resource_attributes,
      # filter: filter_attributes,
      # sort: sort_attributes,
      # check_contract: check_contract_attributes,
      # paginate: check_paginate_attributes
    }

    @result = service.send(params[:action], input)
  end

  def resource
    params[:id] ? Currency.find(params[:id]) : Currency
  end

  def resource_attributes
    params.fetch(:coin, {}).permit!.to_h
  end

  # def filter_attributes
  #   params.fetch(:filter, {}).permit!.to_h
  # end

  # def sort_attributes
  #   params.fetch(:sort, {}).permit!.to_h
  # end

  # def check_contract_attributes
  #   params.fetch(:check_contract, {}).permit!.to_h
  # end

  # def check_paginate_attributes
  #   params.fetch(:paginate, {}).permit!.to_h
  # end

  def default_includes
    ["address", "creator", "travellers", "travellers.document", "contract", "conference"]
  end
end
