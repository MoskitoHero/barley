# frozen_string_literal: true

require "test_helper"

module Barley
  class SerializerTest < ActiveSupport::TestCase
    setup do
      @user = users(:one)
      Barley.configure do |config|
        config.cache_store = ActiveSupport::Cache::MemoryStore.new
      end
    end

    test "it serializes a model" do
      serializer = UserSerializer.new(@user)
      expected = {
        id: @user.id,
        email: @user.email,
        created_at: @user.created_at,
        updated_at: @user.updated_at,
        groups: @user.groups.map { |g| g.as_json(serializer: UserSerializer::GroupSerializer) },
        profile: @user.profile.as_json(serializer: UserSerializer::ProfileSerializer)
      }
      assert_equal(expected, serializer.serializable_hash)
    end

    test "it serializes a model with a custom serializer" do
      serializer = Class.new(Barley::Serializer) do
        attributes :id, :email
      end
      assert_equal({id: @user.id, email: @user.email}, serializer.new(@user).serializable_hash)
    end

    test "it serializes a model with a custom serializer and cache" do
      serializer = Class.new(Barley::Serializer) do
        attributes :id, :email
      end
      assert_equal({id: @user.id, email: @user.email}, serializer.new(@user, cache: true).serializable_hash)
    end

    test "it serializes with a custom attribute" do
      serializer = Class.new(Barley::Serializer) do
        attributes :id, :email

        attribute :note do
          "new note"
        end

        attribute :username do
          object.email.tr("@", "_")
        end

        attribute :created_at, key_name: :creation_date
      end
      expected = {
        id: @user.id,
        email: @user.email,
        note: "new note",
        username: @user.email.tr("@", "_"),
        creation_date: @user.created_at
      }
      assert_equal(expected, serializer.new(@user).serializable_hash)
    end

    test "it serializes with a block on associations" do
      serializer = Class.new(Barley::Serializer) do
        attributes :id, :email

        many :groups do
          attributes :id, :name
        end

        one :profile do
          attribute :id

          attribute :info do
            "#{object.name} (#{object.age})"
          end
        end
      end
      expected = {
        id: @user.id,
        email: @user.email,
        groups: @user.groups.map { |g| {id: g.id, name: g.name} },
        profile: {id: @user.profile.id, info: "#{@user.profile.name} (#{@user.profile.age})"}
      }
      assert_equal(expected, serializer.new(@user).serializable_hash)
    end

    test "it serializes with nested blocks on associations" do
      serializer = Class.new(Barley::Serializer) do
        attributes :id, :email

        many :groups do
          attributes :id, :name

          many :users do
            attributes :id, :email
          end
        end
      end
      expected = {
        id: @user.id,
        email: @user.email,
        groups: @user.groups.map do |g|
          {
            id: g.id,
            name: g.name,
            users: g.users.map { |u| {id: u.id, email: u.email} }
          }
        end
      }
      assert_equal(expected, serializer.new(@user).serializable_hash)
    end

    test "it raises an error when Serializer class has no attributes" do
      serializer = Class.new(Barley::Serializer) do
      end
      assert_raises Barley::Error do
        serializer.new(@user).serializable_hash
      end
    end

    test "it serializes with context" do
      serializer = Class.new(Barley::Serializer) do
        attributes :id, :email

        attribute :note do
          context.note
        end
      end
      expected = {
        id: @user.id,
        email: @user.email,
        note: "new note"
      }
      assert_equal(expected, serializer.new(@user).with_context(note: "new note").serializable_hash)
    end

    test "it serializes with a context object given to the initializer" do
      my_context = Struct.new(:note).new("new note")
      serializer = Class.new(Barley::Serializer) do
        attributes :id, :email

        attribute :note do
          context.note
        end
      end
      expected = {
        id: @user.id,
        email: @user.email,
        note: "new note"
      }
      assert_equal(expected, serializer.new(@user, context: my_context).serializable_hash)
    end

    test "it serializes a many association with a named scope" do
      serializer = Class.new(Barley::Serializer) do
        attributes :id, :email

        many :groups, scope: :active do
          attributes :id, :name
        end
      end
      expected = {
        id: @user.id,
        email: @user.email,
        groups: @user.groups.active.map { |g| {id: g.id, name: g.name} }
      }
      assert_equal(expected, serializer.new(@user).serializable_hash)
    end

    test "it serializes a many association with a lambda scope" do
      serializer = Class.new(Barley::Serializer) do
        attributes :id, :email

        many :groups, scope: -> { limit(1) } do
          attributes :id, :name
        end
      end
      expected = {
        id: @user.id,
        email: @user.email,
        groups: @user.groups.limit(1).map { |g| {id: g.id, name: g.name} }
      }
      assert_equal(expected, serializer.new(@user).serializable_hash)
    end

    test "it serializes an attribute with a coercible type" do
      serializer = Class.new(Barley::Serializer) do
        attribute :age, type: Types::Coercible::String
      end
      assert_equal({age: @user.profile.age.to_s}, serializer.new(@user.profile).serializable_hash)
    end

    test "it raises an InvalidAttributeError when an attribute is not coercible" do
      serializer = Class.new(Barley::Serializer) do
        attribute :age, type: Types::Coercible::Integer
      end
      object = Struct.new(:age).new("not an integer")
      assert_raises Barley::InvalidAttributeError do
        serializer.new(object).serializable_hash
      end
    end

    test "it gives a readable message to the InvalidAttributeError" do
      serializer = Class.new(Barley::Serializer) do
        attribute :age, type: Types::Coercible::Integer
      end
      object = Struct.new(:age).new({})
      begin
        serializer.new(object).serializable_hash
      rescue Barley::InvalidAttributeError => e
        assert_equal "Invalid value type found for attribute age::Integer: {}::Hash", e.message
      end
    end

    test "it raises an InvalidAttributeError when an attribute is not strictly typed" do
      serializer = Class.new(Barley::Serializer) do
        attribute :age, type: Types::Strict::Integer
      end
      object = Struct.new(:age).new(nil)
      assert_raises Barley::InvalidAttributeError do
        serializer.new(object).serializable_hash
      end
    end
  end
end
