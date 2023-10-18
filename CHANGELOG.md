# Changelog

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
