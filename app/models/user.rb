class User < ApplicationRecord
  mount_uploader :avatar, AvatarUploader
  validates_uniqueness_of :mistaken_name
end
