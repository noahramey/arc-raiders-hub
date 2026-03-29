class Quest < ApplicationRecord
  validates :external_id, presence: true, uniqueness: true
  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
end
