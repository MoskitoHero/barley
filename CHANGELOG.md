# Changelog

## 0.9.0 (2024-04-29)

### 💥 BREAKING CHANGES
- `except` and `only` keywords introduced in 0.7.0 are now removed from `Serializer.new` arguments. They are still available on the `Model.as_json` method.

### 🧹 Refactoring
- Major performance improvements, both with and without YJIT enabled. This represents an average 60% speed increase and 3 times smaller memory footprint.

### 🛠️ Chores
- Updated the link to benchmarks

## 0.8.0 (2025-04-25)

### 🛠 Chores
  - Drop support for EOL Ruby versions < 3.2
  - Drop support for EOL Rails versions < 7.1
  - Update dependencies and github actions accordingly

## v0.7.0 (2024-09-25)

### ✨New features
- Added the `only` and `except` options to the `attributes` method. This allows you to specify which attributes to include or exclude from the serialization. Will also work with nested associations.
    ```ruby
    class UserSerializer < Barley::Serializer
        attributes :id, :name, :email
    end

    Serializer.new(User.last, only: [:id, :name]).serializable_hash
    # => { id: 1, name: "John Doe" }
    User.last.as_json(only: [:id, :name])
    # => { id: 1, name: "John Doe" }
    ```
    ```ruby
    class UserSerializer < Barley::Serializer
        attributes :id, :name, :email
    end

    Serializer.new(User.last, except: [:email]).serializable_hash
    # => { id: 1, name: "John Doe" }
    ```
    See the README for more details.
- Added the possibility to pass the context to a `scope` proc / lambda in a `many` association.
    ```ruby
    class UserSerializer < Barley::Serializer
        attributes :id, :name
        many :posts, scope: ->(context) { where("language > ?", context[:language]) } do
            attributes :id, :title
        end
    end

    Serializer.new(User.last, context: {language: "en_US"}).serializable_hash
    # => { id: 1, name: "John Doe", posts: [{ id: 1, title: "My first post" }] }
    ```
    See the README for more details.

## v0.6.2 (2024-06-17)

### ✨New features
- Improved error handling of type inconsistencies: now the serializer will raise a `Barley::InvalidAttributeError` if the object's attribute is not of the specified type. This error will include the attribute name, the expected type, and the actual type of the attribute.
    ```ruby
    class UserSerializer < Barley::Serializer
        attributes name: Types::Strict::Integer
    end

    Serializer.new(User.last).serializable_hash
    # => Barley::InvalidAttributeError: Invalid value type found for attribute name::Integer: Bob::String"
    ```

## v0.6.1 (2024-06-14)

`v0.6.1` is a patch release that fixes a bug in the `scope` argument of the `many` method.

## v0.6.0 (2024-06-14)

### ✨New features
- Added the `context` argument to the serializer's `initialize` method. This allows you to pass a context hash to the serializer, which can be used to pass arguments to the serializer, that can be used with a `context` object within the serializer definition.
    ```ruby
    class UserSerializer < Barley::Serializer
        attributes :id, :name

        def name
        if context[:upcase]
            object.name.upcase
        else
            object.name
        end
        end
    end

    Serializer.new(User.last, context: {upcase: true}).serializable_hash
    # => { id: 1, name: "JOHN DOE" }
    ```
    As a side effect, the context is now available in nested associations as well.
- Added the `scope` argument to the `many` method. This scope can either be a keyword referring to a named scope available on the object, or a lambda that will be called with the object as an argument. This allows you to filter the associated objects.
    ```ruby
    class UserSerializer < Barley::Serializer
        attributes :id, :name
        many :posts, scope: :published do
            attributes :id, :title
        end

        many :posts, key: :popular, scope: -> { where("views > 10_000").order(views: :desc).limit(5) } do
            attributes :id, :title
        end
    end
    ```
    See the README for more details.
### 📝 Documentation
- Updated the README to include the new `context` and `scope` arguments.
### 🧪 Tests
- Added tests for the `context` and `scope` arguments
### 🛠️ Chores
- Updated github actions image to v4

## v0.5.0 (2024-04-19)
### ✨New features
- Added the `with_context` method to the serializer. This method allows you to pass a context hash to the serializer, which can be used to pass arguments to the serializer, that can be used with a `context` object within the serializer definition.
    ```ruby
    class UserSerializer < Barley::Serializer
        attributes :id, :name

        def name
        if context[:upcase]
            object.name.upcase
        else
            object.name
        end
        end
    end

    Serializer.new(User.last).with_context(upcase: true).serializable_hash
    # => { id: 1, name: "JOHN DOE" }
    ```
    See the README for more details.
### 📝 Documentation
- Updated the README to include the new `with_context` method.
### 🧪 Tests
- Added tests for the `with_context` method
- Added benchmark tests

## v0.4.1 (2023-10-27)
### 🐛 Bug fixes
- Fixed the `as_json` method to comply with rails standards. It now accepts an `option` hash as an argument, which allows usage on an `Array` - and therefore on `ActiveRecord::Relation` - as well as on a single object. Updated the documentation to reflect this change. This does not break compatibility with previous versions.

## v0.4.0 (2023-10-19)
### ✨New features
- Added type-checking to the `attributes` and `attribute` methods. Now you can do:
  ```ruby
  attributes id: Types::Strict::Integer, name: Types::Strict::String
  attribute :created_at, type: Types::Strict::Time
  ```
  and the serializer will raise an error if the object's attribute is not of the specified type. See the README for more details.
### 📝 Documentation
- Updated the README to include the new type-checking feature.
- Added YARD documentation. API documentation is available [here](https://rubydoc.info/github/MoskitoHero/barley/main)


## v0.3.0 (2023-10-18)
### ✨New features
- Expanded Barley::Serializer and Barley::Serializable to handle optional root serialization.
```ruby
User.last.as_json(root: true)
# => { user: { id: 1, name: "John Doe", email: "john.doe@example" } }
```
### 🐛 Bug fixes
- Fix the cache key when no `updated_at` column is defined
### 🧪 Tests
- Also updated the relevant test cases to verify the new functionality.
### 🧹 Refactoring
- The 'as_json' method was replaced with 'serializable_hash' in the Serializer.

## v0.2.0 (2023-10-11)
### ✨New features
- Added the ability to define associations with blocks. [They can be nested all the way](https://github.com/MoskitoHero/barley#associations-with-blocks), so you can do:
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

      one :profile, key_name: :author_profile do
        attributes :id, :bio
      end
    end
  end
  ```
- Added the ability to define a key name on `attribute`, `one` and `many` associations.
  ```ruby
  attribute :created_at, key_name: :post_created_at

  one :author, key_name: :post_author

  many :comments, key_name: :post_comments do
    attributes :id, :body
  end
  ```
### 🐛 Bug fixes
- Changed the cache key to use the object class name.

### 📝 Documentation
- Updated README and CHANGELOG

### 🧪 Tests
- Added tests on serializer.rb

### 🧹 Refactoring
- Reorganized the code in serializer.rb
- Updated RBS method signatures

## v0.1.0 (2023-10-10)
- Initial release
