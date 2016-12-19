class User < ApplicationRecord
  mount_uploader :avatar, AvatarUploader
  validates_uniqueness_of :mistaken_name, case_sensitive: false
  validates_presence_of :avatar
end
