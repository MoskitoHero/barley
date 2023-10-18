# frozen_string_literal: true

module Barley
  # Makes a Model serializable
  #
  # * Allows setting a default model Serializer
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
      # @example with cache
      #   serializer ItemSerializer, cache: true
      # @example with cache and expires_in
      #   serializer ItemSerializer, cache: {expires_in: 1.hour}
      def serializer(klass, cache: false)
        define_method(:serializer) do
          klass.new(self, cache: cache)
        end
      end
    end

    included do
      serializer "#{self}Serializer".constantize

      def as_json(serializer: nil, cache: false, root: false)
        serializer ||= self.serializer.class
        serializer.new(self, cache: cache, root: root).serializable_hash
      end
    end
  end
end
