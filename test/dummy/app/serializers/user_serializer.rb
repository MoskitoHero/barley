# frozen_string_literal: true

class UserSerializer < Barley::Serializer
  class ProfileSerializer < Barley::Serializer
    attributes :name, :age
    attribute :birthday do
      object.birthdate.strftime("%m-%d")
    end

    attribute :list_name do
      "#{object.name} (#{object.age})"
    end
  end

  class GroupSerializer < Barley::Serializer
    attributes :name
  end

  attributes :id, :email, :created_at, :updated_at

  many :groups, serializer: GroupSerializer, cache: true
  one :profile, serializer: ProfileSerializer
end
