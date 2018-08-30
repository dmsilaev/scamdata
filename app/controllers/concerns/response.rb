module Response
  def json_response(result, content: true)
    if result.success?
      if content
        render json: result.value!, **serialize_options
      else
        head :no_content
      end
    else
      error = result.value!
      render json: error, status: error[:code]
    end
  end
end
