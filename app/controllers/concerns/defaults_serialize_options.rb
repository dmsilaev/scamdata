module DefaultsSerializeOptions
  def fields_params
    data = params.fetch(:fields, '') || ''
    data = data.is_a?(Array) ? data : data.split(',')
    data = data.concat(default_fields)
    data = data.uniq
    data = data.map(&:to_sym)
    data.empty? ? nil : data
  end

  def include_params
    data = params.fetch(:include, '') || ''
    data = data.is_a?(Array) ? data : data.split(',')
    data = data.concat(default_includes)
    data = data.uniq
    data = data.map(&:to_s)
    data.empty? ? nil : data
  end

  def user_params
    { }
  end

  def default_includes
    []
  end

  def default_fields
    []
  end

  def serialize_options
    options = {}
    options[:fields] = fields_params if fields_params
    options[:include] = include_params if include_params
    options[:scope] = user_params if user_params
    options
  end
end
