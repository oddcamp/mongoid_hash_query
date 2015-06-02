# MongoidHashQuery

## Introduction
__Important: text with ~~strikethrough~~ are future features not yet implemented__

That's the little brother of [ActiveHashRelation](https://github.com/kollegorna/active_hash_relation) gem.

Simple gem that allows you to manipulate Mongoid queries using Hash/JSON. For instance:
```ruby
apply_filters(resource, {name: 'RPK', start_date: {leq: "2014-10-19"}, act_status: "ongoing"})
```
It's perfect for filtering a collection of resources on APIs.

It should be noted that `apply_filters` calls `MongoidHashQuery::FilterApplier` class
underneath with the same params.

_\*A user could retrieve resources based
on unknown attributes (attributes not returned from the API) by brute forcing
which might or might not be a security issue. If you don't like that check
[whitelisting](https://github.com/kollegorna/mongoid_hash_query#whitelisting)._

## Installation

Add this line to your application's Gemfile:

    gem 'mongoid_hash_query'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mongoid_hash_query
    
## How to use
The gem exposes only one method: `apply_filters(resource, hash_params, include_associations: false, model: nil)`. `resource` is expected to be an Mongoid::Criteria.
That way, you can add your custom filters before calling `apply_filters`.

In order to use it you have to include MongoidHashQuery module in your class. For instance in a Rails API controller you would do:

```ruby
class Api::V1::ResourceController < Api::V1::BaseController
  include MongoidHashQuery

  def index
    resources = apply_filters(Resource.all, params)

    authorized_resources = policy_scope(resource)

    render json: resources
  end
end
```

## The API
### Fields
For each param, `apply_filters` method will search in the model (derived from the first param, or explicitly defined as the last param) all the record's field names ~~and associations~~. ~~(filtering based on scopes are not working at the moment but will be supported soon).~~ For each column, if there is such a param, it will apply the filter based on the column type. The following column types are supported:

#### Id
Mongo's documents have an `id`, names `_id` of type BSON::ObjectId. You can just pass in `id` instead of `_id`:
* `{id: 5}`
* ~~`{id: [1,3,4,5,6,7]}`~~

#### Integer, Float, BigDecimal, Date, Time or Datetime
You can apply an equality filter:
* `{example_column: 500}`
or using a hash as a value you get more options:
* `{example_field: {le: 500}}`
* `{example_field: {leq: 500}}`
* `{example_field: {ge: 500}}`
* `{example_field: {geq: 500}}`

Of course you can provide a compination of those like:
* `{example_column: {geq: 500, le: 1000}}`

The same api is for Float, BigDecimal, Date, Time or Datetime.

#### Boolean
I am not sure how Mongoid converts input to boolean but according to [that spec](https://github.com/mongoid/mongoid/blob/master/spec/mongoid/extensions/boolean_spec.rb) a value to be true must be one of the following: `[true, 1, '1', 't', 'T', 'true', 'TRUE']`. Anything else is false. 
* `{example_field: true}`
* `{example_field: 0}`

#### String
You can apply an equality filter:
* `{example_field: test}`

Soon you will be able to send in regex..

### Hash
You can apply an equality filter on hashes like that:
* `{example_field: {foo: 'bar', bar: 'foo'}}`


### Limit
A limit param defines the number of returned resources. For instance:
* `{limit: 10}`

However I would strongly advice you to use a pagination gem like Kaminari, and use `page` and `per_page` params.


### Sorting
You can apply sorting using the `property` and `order` attributes. For instance:
* `{created_at: 'desc'}`

If there is no column named after the property value, sorting is skipped.


### Associations (later)
~~If the association is a `belongs_to` or `has_one`, then the hash key name must be in singular. If the association is `has_many` the attribute must be in plural reflecting the association type. When you have, in your hash, filters for an association, the sub-hash is passed in the association's model. For instance, let's say a user has many microposts and the following filter is applied (could be through an HTTP GET request on controller's index method):~~
* `{email: test@user.com, microposts: {created_at { leq: 12-9-2014} }`


### Scopes
If you want to filter based on a scope in a model, the scope names should go under `scopes` sub-hash. For instance the following:
* `{ scopes: { planned: true } }`

will run the `.planned` scope on the resource.


### Whitelisting
If you don't want to allow a column/association/scope just remove it from the params hash.

#### Filter Classes (later)
~~Sometimes, especially on larger projects, you have specific classes that handle
the input params outside the controllers. You can configure the gem to look for
those classes and call `apply_filters` which will apply the necessary filters when
iterating over associations.~~

~~In an initializer:~~
```ruby
#config/initializers/mongoid_hash_query.rb
MongoidHashQuery.configure do |config|
  config.has_filter_classes = true
  config.filter_class_prefix = 'Api::V1::'
  config.filter_class_suffix = 'Filter'
end
```
~~With the above settings, when the association name is `resource`,
`Api::V1::ResourceFilter.new(resource, params[resource]).apply_filters` will be
called to apply the filters in resource association.~~



## Contributing

1. Fork it ( https://github.com/kollegorna/mongoid_hash_query/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
