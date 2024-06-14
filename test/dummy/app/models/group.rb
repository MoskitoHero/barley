class Group < ApplicationRecord
  include Barley::Serializable

  serializer GroupSerializer, cache: true

  has_many :memberships
  has_many :users, through: :memberships

  scope :active, -> { where(active: true) }
end
