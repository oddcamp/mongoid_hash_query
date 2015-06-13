module MongoidHashQuery::FieldFilters
  def filter_primary(resource, field, param)
    resource = resource.where(id: param)
  end

  def filter_array(resource, field, param)
    return resource
  end

  def filter_big_decimal(resource, field, param)
    return filter_integer(resource, field, param)
  end

  def filter_boolean(resource, field, param)
    return resource.where(field => param)
  end

  def filter_date(resource, field, param)
    return filter_time(resource, field, param)
  end

  def filter_date_time(resource, field, param)
    return filter_time(resource, field, param)
  end

  def filter_float(resource, field, param)
    return filter_integer(resource, field, param)
  end

  def filter_hash(resource, field, param)
    param.each do |k, v|
      if v.is_a?(Hash) && v[:regex]
        resource = resource.where("#{field}.#{k}" => Regexp.new(v[:value], v[:ignore_case]))
      else
        resource = resource.where("#{field}.#{k}" => v)
      end
    end

    return resource
  end

  def filter_integer(resource, field, param)
    if !param.is_a? Hash
      return resource.where(column => param)
    else
      return apply_leq_geq_le_ge_filters(resource, field, param)
    end
  end

  def filter_string(resource, field, param)
    return resource.where(field => param)
  end

  def filter_symbol(resource, field, param)
    return resource.where(field => param)
  end

  def filter_time(resource, field, param)
    if !param.is_a? Hash
      return resource.where(field => param)
    else
      return apply_leq_geq_le_ge_filters(resource, field, param)
    end
  end

  private
    def apply_leq_geq_le_ge_filters(resource, field, param)
      if param[:lte]
        resource = resource.where(field.to_sym.lte => param[:lte])
      elsif param[:lt]
        resource = resource.where(field.to_sym.lt => param[:lt])
      end

      if param[:gte]
        resource = resource.where(field.to_sym.gte => param[:gte])
      elsif param[:gt]
        resource = resource.where(field.to_sym.gt => param[:gt])
      end

      return resource
    end
end
