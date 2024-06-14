# frozen_string_literal: true

require "test_helper"
require "minitest/benchmark"

class BenchmarkTest < Minitest::Benchmark
  def setup
    @user = Struct.new(:id, :email, :created_at, :updated_at, :groups, :profile).new(1, "john@doe.com", Time.now, Time.now, [], nil)
    @serializer = Class.new(Barley::Serializer) do
      attributes :id, :email, :created_at, :updated_at
      one :profile
      many :groups
    end
  end

  def bench_simple_performance
    assert_performance_constant 0.9999 do |n|
      n.times do
        @serializer.new(@user).serializable_hash
      end
    end
  end
end
