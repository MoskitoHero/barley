# frozen_string_literal: true

require "test_helper"
require "generators/serializer/serializable_generator"
require "minitest/mock"

class SerializableGeneratorTest < Rails::Generators::TestCase
  tests SerializableGenerator
  destination Rails.root.join("tmp/generators")
  setup :prepare_destination

  test "should add a serializer file" do
    run_generator %w[post]
    assert_file "app/serializers/post_serializer.rb", /class PostSerializer < Barley::Serializer/
  end

  test "should add a serializer file with custom name" do
    run_generator %w[post --name=CustomPostSerializer]
    assert_file "app/serializers/custom_post_serializer.rb", /class CustomPostSerializer < Barley::Serializer/
  end

  test "should add a serializer test file" do
    run_generator %w[post]
    assert_file "test/serializers/post_serializer_test.rb", /class PostSerializerTest < ActiveSupport::TestCase/
  end

  test "should add a serializer test file with custom name" do
    run_generator %w[post --name=CustomPostSerializer]
    assert_file "test/serializers/custom_post_serializer_test.rb", /class CustomPostSerializerTest < ActiveSupport::TestCase/
  end

  test "should add a serializer spec file" do
    mock = Minitest::Mock.new
    def mock.load
      self
    end

    def mock.specs
      [Struct.new(:name).new("rspec-rails")]
    end

    Bundler.stub :load, mock do
      run_generator %w[post]
      assert_file "spec/serializers/post_serializer_spec.rb", /RSpec.describe PostSerializer do/
    end
  end

  test "should add a serializer spec file with custom name" do
    mock = Minitest::Mock.new
    def mock.load
      self
    end

    def mock.specs
      [Struct.new(:name).new("rspec-rails")]
    end

    Bundler.stub :load, mock do
      run_generator %w[post --name=CustomPostSerializer]
      assert_file "spec/serializers/custom_post_serializer_spec.rb", /RSpec.describe CustomPostSerializer do/
    end
  end

  test "should update the model file" do
    model_path = File.join(destination_root, "app/models")
    FileUtils.mkdir_p(model_path)
    file_name = File.join(model_path, "post.rb")
    File.write(file_name, "class Post < ApplicationRecord\nend")

    run_generator %w[post]
    assert_file "app/models/post.rb", /include Barley::Serializable/
  end
end
