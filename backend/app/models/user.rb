class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  validates :username, presence: true, uniqueness: { case_sensitive: false }

  has_many :saved_builds, dependent: :destroy
  has_many :tracked_items, dependent: :destroy
end
