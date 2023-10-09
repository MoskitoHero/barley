# frozen_string_literal: true

class ProfileSerializer < Barley::Serializer
  attributes :id, :name, :age, :birthdate

  one :user, serializer: UserSerializer, cache: true
end
