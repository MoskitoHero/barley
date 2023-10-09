class User < ApplicationRecord
  include Barley::Serializable

  serializer UserSerializer

  has_many :memberships
  has_many :groups, through: :memberships
  belongs_to :profile
end
