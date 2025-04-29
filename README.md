![Barley loqo](https://i.imgur.com/cJJRA0i.png)

![Test suite badge](https://github.com/MoskitoHero/barley/actions/workflows/ruby.yml/badge.svg)
[![Gem Version](https://badge.fury.io/rb/barley.svg)](https://badge.fury.io/rb/barley)
![Static Badge](https://img.shields.io/badge/Cereal%20-%20100%25%20-%20darklime)

Barley is a fast and efficient ActiveModel serializer.

Cerealize your ActiveModel objects into flat hashes with a clear, yet versatile DSL, and caching and type-checking baked in. Our daily bread is to make your API faster.

You don't believe us? Check out the [benchmarks](https://github.com/MoskitoHero/barley/tree/main/benchmarks#readme). 😎

## API documentation
[Check out the API documentation here](https://rubydoc.info/github/MoskitoHero/barley/main).

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

  attributes id: Types::Strict::Integer, :name

  attribute :email
  attribute :value, type: Types::Coercible::Integer

  many :posts

  many :posts, key_name: :featured, scope: :featured

  many :posts, key_name: :popular, scope: -> { where("views > 10_000").limit(3) }

  many :posts, key_name: :in_current_language, scope: -> (context) { where(language: context.language) }

  one :group, serializer: CustomGroupSerializer

  many :related_users, key: :friends, cache: true

  one :profile, cache: { expires_in: 1.day } do
    attributes :avatar, :social_url

    attribute :badges do
      object.badges.map(&:display_name)
    end
  end

end
```

Then just use the `as_json` method on your model.

```ruby
user = User.find(1)
user.as_json(only: [:id, :name, posts: [:id, :title]])
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

You can also set a custom key name for the attribute with the `key_name` option.

```ruby
  attribute :updated_at, key: :last_change
```

### Associations

#### One-to-one
You can define a one-to-one association with the `one` macro.

```ruby
  one :group
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

##### Key name

You can also pass a key name for the association with the `key_name` option.

```ruby
  one :group, key_name: :team
```

#### One-to-many
You can define a one-to-many association with the `many` macro.

```ruby
  many :posts
```

##### Custom serializer and caching

You can define a custom serializer for the association with the `serializer` option, and / or caching options with the `cache` option.

```ruby
  many :posts, serializer: CustomPostSerializer, cache: { expires_in: 1.hour }
```

##### Scope
You can pass a scope to the association with the `scope` option. It can either be a symbol referencing a named scope on your associated model, or a lambda.

```ruby
  many :posts, scope: :published # given you have a scope named `published` on your Post model
```

```ruby
  many :posts, scope: -> { where(published: true).limit(4) }
```

You can also pass a context to the lambda. See the [context section](#context) for more details.

```ruby
  many :posts, scope: -> (context) { where(language: context.language) }
```

##### Key name
You can also pass a key name for the association with the `key_name` option.

```ruby
  many :posts, key_name: :articles
```

### Associations with blocks
Feel like using a block to define your associations? You can do that too.

```ruby
  one :group do
    attributes :id, :name
  end
```

```ruby
  many :posts do
    attributes :id, :title, :body

    one :author do
      attributes :name, :email
    end
  end
```

Of course, all the options available for the `one` and `many` macros are also available for the block syntax.

```ruby
  many :posts, key_name: :featured do
    attributes :id, :title, :body
  end
```

## Context

You can pass a context to the serializer with the `with_context` method.

```ruby
serializer = PostSerializer.new(Post.last).with_context(current_user: current_user)
```

This context will be available in the serializer with the `context` method. It is also available in nested serializers.

```ruby
class PostSerializer < Barley::Serializer
  attributes :id, :title, :body

  attribute :is_owner do
    object.user == context.current_user
  end

  many :comments do
    many :likes do
      attribute :is_owner do
        object.user == context.current_user # context is here too!
      end
    end
  end
end
```

The context is also available in the scope of the lambda passed to the `scope` option of the `many` macro. See the [scope section](#scope) for more details.

```ruby
  many :posts, scope: -> (context) { where(language: context.language) }
```

### Using a custom context object
Barley generates a Struct from the context hash you pass to the with_context method. But you can also pass a custom context object directly in the initializer instead.

```ruby
my_context = Struct.new(:current_user).new(current_user)

serializer = PostSerializer.new(Post.last, context: my_context)
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

Beware, this gem overrides the `as_json` method on your model. Calling `as_json` with `include`, `only`, or `except` options will not work as expected.

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
end
```

## Type checking
Barley can check the type of the object you are serializing with the [dry-types](https://dry-rb.org/gems/dry-types/main/) gem.

It will raise an error if the object is not of the expected type, or coerce it to the correct type and perform constraints checks.

```ruby
module Types
  include Dry.Types()
end

class UserSerializer < Barley::Serializer
  attributes id: Types::Strict::Integer, name: Types::Strict::String, email: Types::Strict::String.constrained(format: URI::MailTo::EMAIL_REGEXP)

  attribute :role, type: Types::Coercible::String do
    object.role.integer_or_string_coercible_value
  end
end
```

Check out [dry-types](https://dry-rb.org/gems/dry-types/main/) for all options and available types.

## Breakfast mode 🤡 (coming soon)
You will soon be able to replace all occurrences of `Serializer` with `Cerealizer` in your codebase. Just for fun. And for free.

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

*Note: we are thinking about adding a `Surrealizer` class for the most advanced users. Stay tuned.*

## JSON:API
Barley does not serialize to the JSON:API standard. We prefer to keep it simple and fast.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

The logo is made from an asset from [onlinewebfonts.com](https://www.onlinewebfonts.com/icon), licensed by CC BY 4.0.

## Contributing
You can contribute in several ways: reporting bugs, suggesting features, or contributing code. See [our contributing guidelines](CONTRIBUTING.md)

Make sure you adhere to [our code of conduct](CODE_OF_CONDUCT.md). We aim to keep this project open and inclusive.

## Security

Please refer to our [security guidelines](SECURITY.md)
