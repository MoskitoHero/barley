class Profile < ApplicationRecord
  include Barley::Serializable

  has_one :user
end
