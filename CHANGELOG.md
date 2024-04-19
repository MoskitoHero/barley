# Changelog

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
