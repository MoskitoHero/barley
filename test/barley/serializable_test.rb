# frozen_string_literal: true

require "test_helper"
require "minitest/mock"

class DummyModelSerializer < Barley::Serializer
end

class OtherDummyModelSerializer < Barley::Serializer
end

module Barley
  class SerializableTest < ActiveSupport::TestCase
    def setup
      @model = DummyModel
    end

    test "it provides a default serializer named after the model name" do
      assert_instance_of(DummyModelSerializer, @model.new.serializer)
    end

    test "it uses the serializer defined in the model" do
      model = OtherDummyModel.new
      assert_instance_of(CustomOtherDummyModelSerializer, model.serializer)
    end

    test "as_json calls the serializer" do
      model = @model.new
      mock = Minitest::Mock.new
      serializer_mock = Minitest::Mock.new
      mock.expect(:class, mock)
      mock.expect(:new, serializer_mock, [model], cache: false, root: false)
      serializer_mock.expect(:serializable_hash, {}, [])

      model.stub(:serializer, mock) do
        model.as_json
      end

      mock.verify
      serializer_mock.verify
    end

    test "as_json with a custom serializer calls the serializer" do
      model = @model.new
      mock = Minitest::Mock.new
      mock.expect(:serializable_hash, {}, [])
      OtherDummyModelSerializer.stub(:new, mock) do
        model.as_json(serializer: OtherDummyModelSerializer)
      end
      mock.verify
    end

    test "as_json with cache calls the serializer with cache" do
      model = @model.new
      mock = Minitest::Mock.new
      serializer_mock = Minitest::Mock.new
      mock.expect(:class, mock)
      mock.expect(:new, serializer_mock, [model], cache: true, root: false)
      serializer_mock.expect(:serializable_hash, {}, [])

      model.stub(:serializer, mock) do
        model.as_json(cache: true)
      end

      mock.verify
      serializer_mock.verify
    end

    test "as_json with cache and expires_in calls the serializer with cache and expires_in" do
      model = @model.new
      mock = Minitest::Mock.new
      serializer_mock = Minitest::Mock.new
      mock.expect(:class, mock)
      mock.expect(:new, serializer_mock, [model], cache: {expires_in: 1.hour}, root: false)
      serializer_mock.expect(:serializable_hash, {}, [])

      model.stub(:serializer, mock) do
        model.as_json(cache: {expires_in: 1.hour})
      end

      mock.verify
      serializer_mock.verify
    end

    test "as_json with root calls the serializer with root" do
      model = @model.new
      mock = Minitest::Mock.new
      serializer_mock = Minitest::Mock.new
      mock.expect(:class, mock)
      mock.expect(:new, serializer_mock, [model], cache: false, root: true)
      serializer_mock.expect(:serializable_hash, {}, [])

      model.stub(:serializer, mock) do
        model.as_json(root: true)
      end

      mock.verify
      serializer_mock.verify
    end

    test "serializer raises error if default serializer is not defined" do
      assert_raises(Barley::Error) do
        Class.new do
          include Barley::Serializable
        end.new.serializer
      end
    end

    test "as_json raises error if custom serializer is not defined" do
      model = @model.new
      assert_raises(Barley::Error) do
        model.as_json
      end
    end

    test "as_json with only option calls the serializer with only option" do
      model = @model.new
      mock = Minitest::Mock.new
      serializer_mock = Minitest::Mock.new
      mock.expect(:class, mock)
      mock.expect(:new, serializer_mock, [model], cache: false, root: false)
      serializer_mock.expect(:serializable_hash, {}, [])

      model.stub(:serializer, mock) do
        model.as_json(only: [:name])
      end

      mock.verify
      serializer_mock.verify
    end

    test "as_json with except option calls the serializer with except option" do
      model = @model.new
      mock = Minitest::Mock.new
      serializer_mock = Minitest::Mock.new
      mock.expect(:class, mock)
      mock.expect(:new, serializer_mock, [model], cache: false, root: false)
      serializer_mock.expect(:serializable_hash, {}, [])

      model.stub(:serializer, mock) do
        model.as_json(except: [:name])
      end

      mock.verify
      serializer_mock.verify
    end
  end
end

class CustomOtherDummyModelSerializer < Barley::Serializer
end

class DummyModel
  include Barley::Serializable
end

class OtherDummyModel
  include Barley::Serializable

  serializer CustomOtherDummyModelSerializer
end
