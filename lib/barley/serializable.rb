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
      serializer "#{self}Serializer".constantize

      # Serializes the model
      #
      # @note this method does not provide default rails options like `only` or `except`.
      #   This is because the Barley serializer should be the only place where the attributes are defined.
      #
      # @param serializer [Class] the serializer to use
      # @param cache [Boolean, Hash<Symbol, ActiveSupport::Duration>] whether to cache the result, or a hash with options for the cache
      # @param root [Boolean] whether to include the root key in the hash
      #
      # @return [Hash] the serialized attributes
      def as_json(serializer: nil, cache: false, root: false)
        serializer ||= self.serializer.class
        serializer.new(self, cache: cache, root: root).serializable_hash
      end
    end
  end
end
