module MongoidHashQuery
  class Aggregation
    include Helpers

    attr_reader :configuration, :params, :resource, :model

    def initialize(resource, params, model: nil)
      @configuration = Module.nesting.last.configuration
      @resource = resource
      @params = HashWithIndifferentAccess.new(params)
      @model = model

      unless @model
        @model = model_class_name(@resource)
      end
    end

    def apply
      if params[:aggregate].is_a? Hash
        meta_attributes = HashWithIndifferentAccess.new

        params[:aggregate].each do |field, asked_aggrs|
          #next if @model.fields[field].nil? #allow on embedded documents too
          next unless params[:aggregate][field].is_a? Hash

          if @model.fields[field]
            case @model.fields[field].options[:type].to_s.downcase.to_sym
            when :integer, :float, :bigdecimal
              meta_attributes[field] = apply_aggregations(
                {avg: :avg, sum: :sum, max: :max, min: :min},
                params[:aggregate][field],
                field
              )

            when :date, :datetime, :time, :timewithzone,
              meta_attributes[field] = apply_aggregations(
                {max: :max, min: :min},
                params[:aggregate][field],
                field
              )
            end
          else
            meta_attributes[field] = apply_aggregations(
              {avg: :avg, sum: :sum, max: :max, min: :min},
              params[:aggregate][field],
              field
            )
          end
        end
      end

      return {aggregations: meta_attributes}
    end

    def apply_aggregations(available_aggr, asked_aggr, field)
      meta_attributes = HashWithIndifferentAccess.new

      available_aggr.each do |k, v|
        if asked_aggr[k]
          meta_attributes[k] = resource.send(v,field)
          meta_attributes[k] = meta_attributes[k].to_f if meta_attributes[k].is_a? BigDecimal
        end
      end

      return meta_attributes
    end
  end
end
