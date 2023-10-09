# frozen_string_literal: true

class GroupSerializer < Barley::Serializer
  class UserSerializer < Barley::Serializer
    attributes :email

    attribute :profile do
      object.profile.age
    end
  end

  attributes :id, :name

  many :users, serializer: GroupSerializer::UserSerializer
end
