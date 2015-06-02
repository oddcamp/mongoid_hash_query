module MongoidHashQuery::SortFilters
  def apply_sort(resource, params)
    if !params.is_a? Hash
      return resource
    else
      params.each do |k, v|
        resource = resource.order_by([k, v || :asc])
      end

      return resource
    end
  end
end
