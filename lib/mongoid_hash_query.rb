require 'mongoid_hash_query/version'
require 'mongoid_hash_query/field_filters'
require 'mongoid_hash_query/limit_filters'
require 'mongoid_hash_query/sort_filters'
require 'mongoid_hash_query/scope_filters'
require 'mongoid_hash_query/filter_applier'

module MongoidHashQuery
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration
    yield(configuration)
  end

  def self.configuration
    @configuration ||= Configuration.new do
      self.has_filter_classes = false
    end
  end

  def apply_filters(resource, params, include_associations: false, model: nil)
    FilterApplier.new(
      resource,
      params,
      include_associations: include_associations,
      model: model
    ).apply_filters
  end

  class Configuration
    attr_accessor :has_filter_classes, :filter_class_prefix, :filter_class_suffix
  end
end
