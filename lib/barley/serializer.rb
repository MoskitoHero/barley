# frozen_string_literal: true

module Barley
  class Serializer
    EMPTY_ARRAY = [].freeze
    EMPTY_HASH = {}.freeze

    attr_accessor :object, :context

    class << self
      attr_accessor :defined_attributes

      # Defines attributes for the serializer
      #
      # Accepts either a list of symbols or a hash of symbols and Dry::Types, or a mix of both
      #
      # @example only symbols
      #   attributes :id, :name, :email
      #   # => {id: 1234, name: "John Doe", email: "john.doe@example"}
      #
      # @example with types
      #   attributes id: Types::Strict::Integer, name: Types::Strict::String, email: Types::Strict::String
      #   # => {id: 1234, name: "John Doe", email: "john.doe@example"}
      #
      # @example with types and symbols
      #   attributes :id, name: Types::Strict::String, email: Types::Strict::String
      #   # => {id: 1234, name: "John Doe", email: "john.doe@example"}
      #
      # @see Serializer#attribute
      #
      # @param keys [Hash<Symbol, Dry::Types>, Array<Symbol>] mix of symbols and hashes of symbols and Dry::Types
      def attributes(*keys)
        if keys.last.is_a?(Hash)
          keys.pop.each do |key, type|
            attribute(key, type: type)
          end
        end
        keys.each do |key|
          if key.is_a?(Hash)
            attribute(key.keys.first, type: key.values.first)
          else
            attribute(key)
          end
        end
      end

      # Defines a single attribute for the serializer
      #
      # Type checking is done with Dry::Types. If a type is not provided, the value is returned as is.
      # Dry::Types can be used to coerce the value to the desired type and to check constraints.
      #
      # @see https://dry-rb.org/gems/dry-types/main/
      #
      # @raise [Dry::Types::ConstraintError] if the type does not match
      #
      # @example simple attribute
      #   attribute :id
      #   # => {id: 1234}
      #
      # @example attribute with a different key name
      #   attribute :name, key_name: :full_name
      #   # => {full_name: "John Doe"}
      #
      # @example attribute with a type
      #   attribute :email, type: Types::Strict::String
      #   # => {email: "john.doe@example"}
      #
      # @example attribute with a type and a block
      #   attribute :email, type: Types::Strict::String do
      #     object.email.upcase
      #   end
      #   # => {email: "JOHN.DOE@EXAMPLE"}
      #
      # @param key [Symbol] the attribute name
      # @param key_name [Symbol] the key name in the hash
      # @param type [Dry::Types] the type to use, or coerce the value to
      # @param block [Proc] a block to use to compute the value
      # @raise [Barley::InvalidAttributeError] if the value does not match the type - when a type is provided
      def attribute(key, key_name: nil, type: nil, &block)
        key_name ||= key
        define_method(key_name) do
          value = block ? instance_eval(&block) : object.send(key)
          if type.nil?
            value
          else
            unless type.valid?(value)
              raise Barley::InvalidAttributeError,
                    "Invalid value type found for attribute #{key_name}::#{type.name}: #{value}::#{value.class}"
            end

            type[value]
          end
        end

        self.defined_attributes = (defined_attributes || []) << key_name
      end

      # Defines a single association for the serializer
      #
      # @example using the default serializer of the associated model
      #   one :group
      #   # => {group: {id: 1234, name: "Group 1"}}
      #
      # @example using a custom serializer
      #   one :group, serializer: MyCustomGroupSerializer
      #   # => {group: {id: 1234, name: "Group 1"}}
      #
      # @example using a block with an inline serializer definition
      #   one :group do
      #     attributes :id, :name
      #   end
      #   # => {group: {id: 1234, name: "Group 1"}}
      #
      # @example using a different key name
      #   one :group, key_name: :my_group
      #   # => {my_group: {id: 1234, name: "Group 1"}}
      #
      # @example using cache
      #   one :group, cache: true
      #   # => {group: {id: 1234, name: "Group 1"}}
      #
      # @example using cache and expires_in
      #   one :group, cache: {expires_in: 1.hour}
      #   # => {group: {id: 1234, name: "Group 1"}}
      #
      # @param key [Symbol] the association name
      # @param key_name [Symbol] the key name in the hash
      # @param serializer [Class] the serializer to use
      # @param cache [Boolean, Hash<Symbol, ActiveSupport::Duration>] whether to cache the result, or a hash with options for the cache
      # @param block [Proc] a block to use to define the serializer inline
      def one(key, key_name: nil, serializer: nil, cache: false, &block)
        key_name ||= key
        resolved_serializer = serializer
        resolved_serializer_from_block = nil
        if block && !serializer
          resolved_serializer_from_block = Class.new(Barley::Serializer) do
            instance_eval(&block)
          end
        end

        define_method(key_name) do
          element = object.send(key)
          return EMPTY_HASH if element.nil?

          el_serializer = resolved_serializer || resolved_serializer_from_block || element.serializer.class

          el_serializer.new(element, cache: cache, context: @context).serializable_hash
        end
        self.defined_attributes = (defined_attributes || []) << key_name
      end

      # Defines a collection association for the serializer
      #
      # @example using the default serializer of the associated model
      #   many :groups
      #   # => {groups: [{id: 1234, name: "Group 1"}, {id: 5678, name: "Group 2"}]}
      #
      # @example using a custom serializer
      #   many :groups, serializer: MyCustomGroupSerializer
      #   # => {groups: [{id: 1234, name: "Group 1"}, {id: 5678, name: "Group 2"}]}
      #
      # @example using a block with an inline serializer definition
      #   many :groups do
      #     attributes :id, :name
      #   end
      #   # => {groups: [{id: 1234, name: "Group 1"}, {id: 5678, name: "Group 2"}]}
      #
      # @example using a different key name
      #   many :groups, key_name: :my_groups
      #   # => {my_groups: [{id: 1234, name: "Group 1"}, {id: 5678, name: "Group 2"}]}
      #
      # @example using cache
      #   many :groups, cache: true
      #   # => {groups: [{id: 1234, name: "Group 1"}, {id: 5678, name: "Group 2"}]}
      #
      # @example using cache and expires_in
      #   many :groups, cache: {expires_in: 1.hour}
      #   # => {groups: [{id: 1234, name: "Group 1"}, {id: 5678, name: "Group 2"}]}
      #
      # @example using a named scope
      #   many :groups, scope: :active # given the scope `active` is defined in the Group model
      #   # => {groups: [{id: 5678, name: "Group 2"}]}
      #
      # @example using a lambda scope
      #   many :groups, scope: -> { order(id: :asc).limit(1) }
      #   # => {groups: [{id: 1234, name: "Group 1"}]}
      # @param key [Symbol] the association name
      # @param key_name [Symbol] the key name in the hash
      # @param serializer [Class] the serializer to use
      # @param cache [Boolean, Hash<Symbol, ActiveSupport::Duration>] whether to cache the result, or a hash with options for the cache
      # @param scope [Symbol, Proc] the scope to use to fetch the elements
      # @param block [Proc] a block to use to define the serializer inline
      def many(key, key_name: nil, serializer: nil, cache: false, scope: nil, &block)
        key_name ||= key
        resolved_serializer = serializer
        resolved_serializer_from_block = nil
        if block && !serializer
          resolved_serializer_from_block = Class.new(Barley::Serializer) do
            instance_eval(&block)
          end
        end

        define_method(key_name) do
          elements = object.send(key)
          return EMPTY_ARRAY if elements.nil? || (elements.respond_to?(:empty?) && elements.empty?)

          if scope
            elements = if scope.is_a?(Symbol)
                         elements.send(scope)
                       else
                         (if scope.arity == 1
                            elements.instance_exec(@context, &scope)
                          else
                            elements.instance_exec(&scope)
                          end)
                       end
          end
          return EMPTY_ARRAY if elements.empty?

          el_serializer_class = resolved_serializer || resolved_serializer_from_block || element.serializer.class
          serializer_instance = el_serializer_class.new(nil, cache: cache, context: @context)

          result = []
          elements.each do |element|
            serializer_instance.object = element
            # This assumes _serializable_hash primarily depends on @object,
            # @context, and @effective_options (set during its own init).
            serialized = serializer_instance.send(:_serializable_hash) # Use send for private method

            next if serialized.nil? || (serialized.respond_to?(:empty?) && serialized.empty?)

            result << serialized
          end

          result
        end
        self.defined_attributes = (defined_attributes || []) << key_name
      end
    end

    # @example with cache
    #   Barley::Serializer.new(object, cache: true)
    #
    # @example with cache and expires_in
    #   Barley::Serializer.new(object, cache: {expires_in: 1.hour})
    #
    # @param object [Object] the object to serialize
    # @param cache [Boolean, Hash<Symbol, ActiveSupport::Duration>] a boolean to cache the result, or a hash with options for the cache
    # @param root [Boolean] whether to include the root key in the hash
    # @param context [Object] an optional context object to pass additional data to the serializer
    def initialize(object, cache: false, root: false, context: nil)
      @object = object
      @context = context
      @root = root
      @cache, @expires_in = if cache.is_a?(Hash)
                              [true, cache[:expires_in]]
                            else
                              [cache, nil]
                            end
    end

    # Serializes the object
    #
    # @return [Hash] the serializable hash
    def serializable_hash
      # Cache check first
      if @cache
        Barley::Cache.fetch(cache_base_key, expires_in: @expires_in) do
          _serializable_hash
        end
      else
        _serializable_hash
      end
    end

    # Clears the cache for the object
    #
    # @param key [String] the cache key
    #
    # @return [Boolean] whether the cache was cleared
    def clear_cache(key: cache_base_key)
      Barley::Cache.delete(key)
    end

    # Sets the context object for the serializer
    #
    # The context object is a Struct built from the given arguments.
    # It can be used to pass additional data to the serializer. The context object is accessible in the serializer with the `context` attribute.
    # @example
    #   serializer.with_context(current_user: current_user, locale: I18n.locale)
    #   # => #<Barley::Serializer:0x00007f8f3b8b3e08 @object=#<Product id: 1, name: "Product 1">, @context=#<struct current_user=1, locale=:en>>
    #   # In the serializer:
    #   attribute :name do
    #     "#{object.name[context.locale]}" # Will use the locale from the context
    #   end
    # @param args [Hash] the context object attributes
    # @return [Barley::Serializer] the serializer
    def with_context(**args)
      @context = Struct.new(*args.keys).new(*args.values)

      self
    end

    private

    # @api private
    #
    # @return [String] the cache key
    def cache_base_key
      if object.respond_to?(:updated_at) && object.updated_at.present?
        "#{object.class.name&.underscore}/#{object.id}/#{object.updated_at&.to_i}/barley_cache/"
      else
        "#{object.class.name&.underscore}/#{object.id}/barley_cache/"
      end
    end

    # @api private
    #
    # @return [Array<Symbol>] the defined attributes
    def defined_attributes
      self.class.defined_attributes
    end

    # Serializes the object
    #
    # @api private
    # @raise [Barley::Error] if no attribute or relation is defined in the serializer
    #
    # @return [Hash] the serializable hash
    def _serializable_hash
      attrs = defined_attributes
      raise Barley::Error, 'No attribute or relation defined in the serializer' if attrs.nil?

      return @root ? { root_key => EMPTY_HASH } : EMPTY_HASH if attrs.nil? || attrs.empty?

      hash = {}
      attrs.each do |key|
        value = send(key)
        hash[key] = value unless value.nil?
      end

      @root ? { root_key => hash } : hash
    end

    # @api private
    #
    # @return [Symbol] the root key, based on the class name
    def root_key
      @root_key = object_class.name.underscore.to_sym
    end
  end
end
