# frozen_string_literal: true

require "test_helper"

class BarleyTest < ActiveSupport::TestCase
  test "it has a version number" do
    assert Barley::VERSION
  end

  test "it has a configuration" do
    assert Barley.config
    assert_instance_of Barley::Configuration, Barley.config, msg: "Barley.config should be a Barley::Configuration"
  end

  test "it updates the configuration" do
    Barley.configure do |config|
      config.cache_store = :memory_store
    end
    assert_equal :memory_store, Barley.config.cache_store
  end

  test "it has a cache store" do
    assert Barley.config.cache_store
  end
end
