class User < ApplicationRecord
  mount_uploader :avatar, AvatarUploader
  validates_uniqueness_of :mistaken_name, case_sensitive: false
  validates_presence_of :mistaken_name, :preferred_name, :avatar
  validate :names_not_same

  def names_not_same
    errors.add(:mistaken_name, "can't be the same as Perferred Name") if mistaken_name == preferred_name
  end
end
