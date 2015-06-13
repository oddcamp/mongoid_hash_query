module MongoidHashQuery::ScopeFilters
  def filter_scopes(resource, params)
    resource.scopes.each do |k, v|
      if params.include?(k)
        resource = resource.send(k)
      end
    end

    return resource
  end
end
