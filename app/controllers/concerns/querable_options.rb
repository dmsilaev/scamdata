module QuerableOptions
  def query_params
    data = params.fetch(:query, {}).permit!.to_h
    data.empty? ? nil : data
  end
end
