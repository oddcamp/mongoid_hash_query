module MongoidHashQuery
  class FilterApplier
    include Helpers
    include FieldFilters
    #include AssociationFilters
    include ScopeFilters
    include SortFilters
    include LimitFilters

    attr_reader :configuration

    def initialize(resource, params, include_associations: true, model: nil)
      @configuration = Module.nesting.last.configuration
      @resource = resource
      @params = HashWithIndifferentAccess.new(params)
      @include_associations = include_associations
      @model = model
    end

    def apply_filters
      unless @model
        @model = model_class_name(@resource)
      end
      #table_name = @model.table_name
      @model.fields.each do |k, v|
        next if @params[v.name.to_s].nil?

        if k.eql?('_id')
          @resource = filter_primary(@resource, v.name, @params[id])
          next
        end

        case v.options[:type].to_s
        when Array.to_s
          @resource = filter_array(@resource, v.name, @params[v.name])
        when BigDecimal.to_s
          @resource = filter_big_decimal(@resource, v.name, @params[v.name])
        when Boolean.to_s
          @resource = filter_boolean(@resource, v.name, @params[v.name])
        when Date.to_s
          @resource = filter_date(@resource, v.name, @params[v.name])
        when DateTime.to_s
          @resource = filter_date_time(@resource, v.name, @params[v.name])
        when Float.to_s
          @resource = filter_float(@resource, v.name, @params[v.name])
        when Hash.to_s
          @resource = filter_hash(@resource, v.name, @params[v.name])
        when Integer.to_s
          @resource = filter_integer(@resource, v.name, @params[v.name])
        when String.to_s
          @resource = filter_string(@resource, v.name, @params[v.name])
        when Symbol.to_s
          @resource = filter_symbol(@resource, v.name, @params[v.name])
        when Time.to_s
          @resource = filter_time(@resource, v.name, @params[v.name])
        else
          @resource = @resource.where(v.name => @params[v.name])
        end
      end

      @resource = filter_scopes(@resource, @params[:scopes]) if @params.include?(:scopes)
      @resource = apply_limit(@resource, @params[:limit]) if @params.include?(:limit)
      @resource = apply_sort(@resource, @params[:sort]) if @params.include?(:sort)

=begin
      @resource = filter_associations(@resource, @params) if @include_associations
=end

      return @resource
    end

  end
end
