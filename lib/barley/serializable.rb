# frozen_string_literal: true

module Barley
  # Makes a Model serializable
  #
  # * Allows setting a default model Serializer
  #
  # @example
  #   class Item < ApplicationRecord
  #     include Barley::Serializable
  #
  #    # optionally define the default serializer, otherwise defaults to ItemSerializer
  #    serializer MyCustomItemSerializer, cache: true
  #   end
  #
  #   #> Item.as_json
  module Serializable
    extend ActiveSupport::Concern

    class_methods do
      # @example without cache
      #   serializer ItemSerializer
      #
      # @example with cache
      #   serializer ItemSerializer, cache: true
      #
      # @example with cache and expires_in
      #   serializer ItemSerializer, cache: {expires_in: 1.hour}
      #
      # @param klass [Class] the serializer class
      # @param cache [Boolean, Hash<Symbol, ActiveSupport::Duration>] whether to cache the result, or a hash with options for the cache
      def serializer(klass, cache: false)
        # We need to silence the warnings because we are defining a method with the same name as the parameter
        # This avoids :
        # - warning: method redefined; discarding old serializer
        # - warning: previous definition of serializer was here
        Kernel.silence_warnings do
          define_method(:serializer) do
            klass.new(self, cache: cache)
          end
        end
      end
    end

    included do
      begin
        serializer "#{self}Serializer".constantize
      rescue NameError
        raise Barley::Error, "Could not find serializer for #{self}. Please define a #{self}Serializer class."
      end

      # Serializes the model
      #
      # @note this method does not provide default rails options like `only` or `except`.
      #   This is because the Barley serializer should be the only place where the attributes are defined.
      #
      # @option options [Class] :serializer the serializer to use
      # @option options [Boolean, Hash<Symbol, ActiveSupport::Duration>] :cache whether to cache the result, or a hash with options for the cache
      # @option options [Boolean] :root whether to include the root key
      #
      # @return [Hash] the serialized attributes
      def as_json(options = nil)
        options ||= {}
        serializer = options[:serializer] || self.serializer.class
        cache = options[:cache] || false
        root = options[:root] || false
        begin
          serializer.new(self, cache: cache, root: root, only: options[:only], except: options[:except]).serializable_hash
        rescue NameError
          raise Barley::Error, "Could not find serializer for #{self}. Please define a #{serializer} class."
        end
      end
    end
  end
end
