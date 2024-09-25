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

    test "serializes with a custom attribute and type" do
      serializer = Class.new(Barley::Serializer) do
        attributes :id, :email

        attribute :age, type: Types::Coercible::Integer do
          object.profile.age
        end
      end
      expected = {
        id: @user.id,
        email: @user.email,
        age: @user.profile.age
      }
      assert_equal(expected, serializer.new(@user).serializable_hash)
    end

    test "serializes with a custom attribute and invalid type" do
      serializer = Class.new(Barley::Serializer) do
        attribute :age, type: Types::Strict::Integer do
          "invalid age"
        end
      end
      assert_raises Barley::InvalidAttributeError do
        serializer.new(@user).serializable_hash
      end
    end

    test "serializes with a custom association and cache" do
      serializer = Class.new(Barley::Serializer) do
        attributes :id, :email

        one :profile, cache: true do
          attributes :id, :name
        end
      end
      expected = {
        id: @user.id,
        email: @user.email,
        profile: {
          id: @user.profile.id,
          name: @user.profile.name
        }
      }
      assert_equal(expected, serializer.new(@user).serializable_hash)
    end

    test "serializes with a custom association and invalid cache" do
      serializer = Class.new(Barley::Serializer) do
        attributes :id, :email

        one :profile, cache: {expires_in: -21.years} do
          attributes :id, :name
        end
      end
      assert_raises ArgumentError do
        serializer.new(@user).serializable_hash
      end
    end

    test "serializes with a nested association and scope" do
      serializer = Class.new(Barley::Serializer) do
        attributes :id, :email

        many :groups, scope: :active do
          attributes :id, :name

          many :users do
            attributes :id, :email
          end
        end
      end
      expected = {
        id: @user.id,
        email: @user.email,
        groups: @user.groups.active.map do |g|
          {
            id: g.id,
            name: g.name,
            users: g.users.map { |u| {id: u.id, email: u.email} }
          }
        end
      }
      assert_equal(expected, serializer.new(@user).serializable_hash)
    end

    test "serializes with a nested association and lambda scope" do
      serializer = Class.new(Barley::Serializer) do
        attributes :id, :email

        many :groups, scope: -> { limit(1) } do
          attributes :id, :name

          many :users do
            attributes :id, :email
          end
        end
      end
      expected = {
        id: @user.id,
        email: @user.email,
        groups: @user.groups.limit(1).map do |g|
          {
            id: g.id,
            name: g.name,
            users: g.users.map { |u| {id: u.id, email: u.email} }
          }
        end
      }
      assert_equal(expected, serializer.new(@user).serializable_hash)
    end

    test "serializes with context passed to a scope" do
      serializer = Class.new(Barley::Serializer) do
        attributes :id, :email

        many :groups, scope: ->(ctx) { limit(ctx.limit) } do
          attributes :id, :name
        end
      end
      context = Struct.new(:limit).new(1)
      expected = {
        id: @user.id,
        email: @user.email,
        groups: @user.groups.limit(1).map do |g|
          {
            id: g.id,
            name: g.name
          }
        end
      }
      assert_equal(expected, serializer.new(@user, context: context).serializable_hash)
    end

    test "serializes with only specified attributes" do
      serializer = Class.new(Barley::Serializer) do
        attributes :id, :email, :created_at, :updated_at
      end
      expected = {
        id: @user.id,
        email: @user.email
      }
      assert_equal(expected, serializer.new(@user, only: %i[id email]).serializable_hash)
    end

    test "serializes with except specified attributes" do
      serializer = Class.new(Barley::Serializer) do
        attributes :id, :email, :created_at, :updated_at
      end
      expected = {
        id: @user.id,
        email: @user.email,
        created_at: @user.created_at
      }
      assert_equal(expected, serializer.new(@user, except: [:updated_at]).serializable_hash)
    end

    test "serializes with only and except combined" do
      serializer = Class.new(Barley::Serializer) do
        attributes :id, :email, :created_at, :updated_at
      end
      expected = {
        id: @user.id
      }
      assert_equal(expected, serializer.new(@user, only: %i[id email], except: [:email]).serializable_hash)
    end

    test "serializes nested associations with only" do
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
        groups: @user.groups.map do |g|
          {
            id: g.id,
            users: g.users.map { |u| {id: u.id} }
          }
        end
      }
      assert_equal(expected,
        serializer.new(@user, only: [:id, {groups: [:id, {users: [:id]}]}]).serializable_hash)
    end

    test "serializes nested associations with except" do
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
            users: g.users.map { |u| {id: u.id} }
          }
        end
      }
      assert_equal(expected, serializer.new(@user, except: [{groups: [{users: [:email]}]}]).serializable_hash)
    end
  end
end
