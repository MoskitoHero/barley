![Barley loqo](./img/barley.png)

Barley is a dead simple, fast, and efficient ActiveModel JSON serializer.

Cerealize your ActiveModel objects into flat JSON objects with a dead simple DSL. Our daily bread is to make your API faster.

## Usage
Add the `Barley::Serializable` module to your ActiveModel object.

```ruby
# /app/models/user.rb
class User < ApplicationRecord
  include Barley::Serializable
end
```

Then define your attributes and associations in a serializer class.

```ruby
# /app/serializers/user_serializer.rb
class UserSerializer < Barley::Serializer
  attributes :id, :name, :email, :created_at, :updated_at

  many :posts
  one :group
end
```

The just use the `as_json` method on your model.

```ruby
user = User.find(1)
user.as_json
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem "barley"
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install barley
```

## Defining the serializer

Barley uses the model name to find the serializer class. For example, if you have a `User` model, Barley will look for a `UserSerializer` class.

You can also define the serializer class with the `serializer` macro.

```ruby
# /app/models/user.rb
class User < ApplicationRecord
  include Barley::Serializable
  
  serializer UserSerializer
end
```

## DSL

### Attributes
You can define attributes with the `attributes` macro.

```ruby
  attributes :id, :name, :email, :created_at, :updated_at
```

You can also define attributes one by one, or a mix of both.

```ruby
  attributes :id, :name, :email
  attribute :created_at
  attribute :updated_at
```

You can also define a custom attribute with a block. You will have a `object` variable available in the block. It is the object you are serializing.

```ruby
  attribute :full_name do
    "#{object.first_name} #{object.last_name}"
  end
```

### Associations

#### One-to-one
You can define a one-to-one association with the `one` macro.

```ruby
  one :group
```

You can also define a custom association with a block. You will have a `object` variable available in the block. It is the object you are serializing.

```ruby
  one :group do
    object.group.name
  end
```

##### Custom serializer and caching
You can define a custom serializer for the association with the `serializer` option, and / or caching options with the `cache` option.

```ruby
  one :group, serializer: CustomGroupSerializer, cache: { expires_in: 1.hour }
```

You can of course define serializers with inner classes for simple needs.

```ruby 
class UserSerializer < Barley::Serializer
  attributes :id, :name, :email, :created_at, :updated_at

  one :group, serializer: LocalGroupSerializer
  
    class LocalGroupSerializer < Barley::Serializer
        attributes :id, :name
    end
end

```
end

#### One-to-many
You can define a one-to-many association with the `many` macro.

```ruby
  many :posts
```

You can also define a custom association with a block. You will have a `object` variable available in the block. It is the object you are serializing.

```ruby
  many :posts do
    object.posts.map(&:title)
  end
```

##### Custom serializer and caching

You can define a custom serializer for the association with the `serializer` option, and / or caching options with the `cache` option.

```ruby
  many :posts, serializer: CustomPostSerializer, cache: { expires_in: 1.hour }
```

## Generators
You have two generators available. One to generate the serializer class:

```shell
rails generate barley:serializer User 
# or
rails generate barley:serializer User --name=CustomUserSerializer
```

And one to generate both the serializer class and add the module to the model:

```shell
rails generate barley:serializable User
# or
rails generate barley:serializable User --name=CustomUserSerializer
```

## Serialization options
You can pass a hash of options to the `as_json` method.

```ruby
user = User.find(1)
user.as_json(serializer: CustomUserSerializer, cache: { expires_in: 1.hour })
```

Beware, this gem overrides the `as_json` method on your model. Calling `as_json` with `include`, `only`, or `except` options will not work.

Why? We believe it defeats the purpose of this gem. If you want to customize the serialization of your model, you should use a serializer class.


## Caching
Barley supports caching out of the box. Just pass `cache: true` to the `serializer` macro.

```ruby
# /app/models/user.rb
# ...
serializer UserSerializer, cache: true
```

Or you can pass a hash of options to the `serializer` macro.

```ruby
# /app/models/user.rb
# ...
serializer UserSerializer, cache: { expires_in: 1.hour }
```

### Caching options
Barley uses the MemoryStore by default. You can change the cache store with the `cache_store` option in an initializer.

```ruby
# /config/initializers/barley.rb
Barley.configure do |config|
  config.cache_store = ActiveSupport::Cache::RedisCacheStore.new
  # config.cache_store = ActiveSupport::Cache::MemoryStore.new
  # config.cache_store = ActiveSupport::Cache::FileStore.new
  # config.cache_store = Rails.cache
end
```

## Breakfast mode 🤡 (coming soon)
You can replace all occurrences of `Serializer` with `Cerealizer` in your codebase. Just for fun. And for free.

```ruby
# /app/models/user.rb
class User < ApplicationRecord
  include Barley::Cerealizable
  
  cerealizer UserCerealizer
end

# app/cerealizers/user_cerealizer.rb
class UserCerealizer < Barley::Cerealizer
  attributes :id, :name, :email, :created_at, :updated_at

  many :posts
  one :group
end
```

```shell
rails generate barley:cerealizer User
# etc.
```

Ah ah ah. This is so funny.

## JSON:API
No. Not yet. Maybe never. We don't know. We don't care. We don't use it. We don't like it. We don't want to. We don't have time. We don't have money. We don't have a life. We don't have a girlfriend. We don't have a boyfriend. We don't have a dog. We don't have a cat. We are generating this readme with Copilot.

## Benchmarks
This gem is blazing fast and efficient. It is 2 to 3 times faster than [ActiveModel::Serializer](https://github.com/rails-api/active_model_serializers) and twice as fast as [FastJsonapi](https://github.com/Netflix/fast_jsonapi). Memory object allocation is also much lower.

With caching enabled, it is just mind-blowing. We think. *Disclaimer: we do not serialize to the JSON:API standard, so that might be the reason why we are so fast.*

This is the result we get with the benchmark script used in the AMS repo on an Apple Silicon M1Pro processor. We will push this benchmark as soon as possible so you can see for yourself.

```shell
bundle exec ruby benchmark.rb
-- create_table("comments", {:force=>:cascade})
-> 0.0128s
-- create_table("posts", {:force=>:cascade})
-> 0.0002s
-- create_table("users", {:force=>:cascade})
-> 0.0002s
Warming up --------------------------------------
ams                    3.000  i/100ms
jsonapi-rb             9.000  i/100ms
barley                 9.000  i/100ms
barley-cache         460.000  i/100ms
ams          eager     8.000  i/100ms
jsonapi-rb   eager    33.000  i/100ms
barley       eager    37.000  i/100ms
barley-cache eager    70.000  i/100ms
Calculating -------------------------------------
ams                    67.770  (± 1.9%) i/s -    657.000  in  10.042270s
jsonapi-rb            157.239  (± 2.3%) i/s -      1.521k in  10.010257s
barley                 96.909  (± 2.4%) i/s -    945.000  in  10.036316s
barley-cache            4.589k (± 2.8%) i/s -     44.620k in  10.010004s
ams          eager     68.237  (± 6.2%) i/s -    592.000  in  10.087602s
jsonapi-rb   eager    289.733  (± 3.7%) i/s -      2.805k in  10.033912s
barley       eager    406.732  (± 3.2%) i/s -      3.922k in  10.020076s
barley-cache eager    639.935  (± 2.4%) i/s -      6.300k in  10.053710s
with 95.0% confidence

Comparison:
barley-cache      :     4589.3 i/s
barley-cache eager:      639.9 i/s - 7.17x  (± 0.27) slower
barley       eager:      406.7 i/s - 11.29x  (± 0.49) slower
jsonapi-rb   eager:      289.7 i/s - 15.83x  (± 0.74) slower
jsonapi-rb        :      157.2 i/s - 29.17x  (± 1.08) slower
barley            :       96.9 i/s - 47.37x  (± 1.75) slower
ams          eager:       68.2 i/s - 67.25x  (± 4.69) slower
ams               :       67.8 i/s - 67.72x  (± 2.31) slower
with 95.0% confidence

Calculating -------------------------------------
ams                    1.300M memsize (   246.338k retained)
16.838k objects (     2.492k retained)
50.000  strings (    50.000  retained)
jsonapi-rb           926.082k memsize (   197.338k retained)
9.565k objects (     1.776k retained)
50.000  strings (    50.000  retained)
barley                 1.102M memsize (   177.490k retained)
12.930k objects (     1.876k retained)
50.000  strings (    35.000  retained)
barley-cache          46.090k memsize (     1.308k retained)
502.000  objects (    17.000  retained)
42.000  strings (     6.000  retained)
ams          eager     1.068M memsize (   233.994k retained)
13.723k objects (     2.308k retained)
50.000  strings (    50.000  retained)
jsonapi-rb   eager   694.430k memsize (   194.826k retained)
6.450k objects (     1.651k retained)
50.000  strings (    50.000  retained)
barley       eager   354.326k memsize (   124.282k retained)
3.694k objects (     1.208k retained)
50.000  strings (    32.000  retained)
barley-cache eager   216.790k memsize (   107.228k retained)
2.376k objects (   956.000  retained)
50.000  strings (    33.000  retained)

Comparison:
barley-cache      :      46090 allocated
barley-cache eager:     216790 allocated - 4.70x more
barley       eager:     354326 allocated - 7.69x more
jsonapi-rb   eager:     694430 allocated - 15.07x more
jsonapi-rb        :     926082 allocated - 20.09x more
ams          eager:    1068038 allocated - 23.17x more
barley            :    1102354 allocated - 23.92x more
ams               :    1299674 allocated - 28.20x more
```

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
