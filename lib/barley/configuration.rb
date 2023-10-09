# frozen_string_literal: true

module Barley
  class Configuration
    attr_accessor :cache_store

    def initialize
      @cache_store = default_cache_store
    end

    private

    def default_cache_store
      ActiveSupport::Cache::MemoryStore.new
    end
  end
end
