# frozen_string_literal: true

module Barley
  class Cache
    class << self
      delegate :fetch, :delete, to: :new
    end

    def initialize
      @cache_store = Barley.config.cache_store
    end

    def fetch(key, options = {}, &block)
      @cache_store.fetch(key, options, &block)
    end

    def delete(key)
      @cache_store.delete(key)
    end
  end
end
