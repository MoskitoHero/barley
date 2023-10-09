# frozen_string_literal: true

module Barley
  class Serializer
    attr_accessor :object

    # @example with cache
    #   Barley::Serializer.new(object, cache: true)
    # @example with cache and expires_in
    #   Barley::Serializer.new(object, cache: {expires_in: 1.hour})
    def initialize(object, cache: false)
      @object = object
      @cache, @expires_in = if cache.is_a?(Hash)
        [true, cache[:expires_in]]
      else
        [cache, nil]
      end
    end

    def self.attributes(*keys)
      keys.each do |key|
        define_method(key) do
          object.send(key)
        end
        set_class_iv(:@defined_attributes, key)
      end
    end

    def self.attribute(key, &block)
      if block
        define_method(key) do
          instance_eval(&block)
        end
      else
        define_method(key) do
          object.send(key)
        end
      end
      set_class_iv(:@defined_attributes, key)
    end

    def self.set_class_iv(iv, key)
      instance_variable_defined?(iv) ? instance_variable_get(iv) << key : instance_variable_set(iv, [key])
    end

    def self.one(key, serializer: nil, cache: false)
      define_method(key) do
        element = object.send(key)
        return {} if element.nil?

        el_serializer = serializer || element.serializer.class
        el_serializer.new(element, cache: cache).as_json
      end
      set_class_iv(:@defined_attributes, key)
    end

    def self.many(key, serializer: nil, cache: false)
      define_method(key) do
        elements = object.send(key)
        return [] if elements.empty?

        el_serializer = serializer || elements.first.serializer.class
        elements.map { |element| el_serializer.new(element, cache: cache).as_json }.reject(&:blank?)
      end
      set_class_iv(:@defined_attributes, key)
    end

    def as_json
      if @cache
        cache_key = cache_base_key
        Barley::Cache.fetch(cache_key, expires_in: @expires_in) do
          _as_json
        end
      else
        _as_json
      end
    end

    def clear_cache(key: cache_base_key)
      Barley::Cache.delete(key)
    end

    private

    def cache_base_key
      "#{self.class.name.underscore}/#{object.id}/#{object.updated_at.to_i}/as_json/"
    end

    def defined_attributes
      self.class.instance_variable_get(:@defined_attributes)
    end

    def _as_json
      hash = {}

      defined_attributes.each do |key|
        hash[key] = send(key)
      end

      hash
    end
  end
end
