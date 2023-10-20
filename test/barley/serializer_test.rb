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
  end
end
