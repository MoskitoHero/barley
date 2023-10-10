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
This gem is blazing fast and efficient. It is 2 to 3 times faster than [ActiveModel::Serializer](https://github.com/rails-api/active_model_serializers) and twice as fast as [FastJsonapi](https://github.com/Netflix/fast_jsonapi).

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
