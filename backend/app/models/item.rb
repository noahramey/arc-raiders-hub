class Item < ApplicationRecord
  validates :external_id, presence: true, uniqueness: true
  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  has_many :tracked_items, dependent: :destroy

  scope :by_rarity, ->(rarity) { where(rarity: rarity) }
  scope :by_category, ->(category) { where(category: category) }
  scope :by_type, ->(item_type) { where(item_type: item_type) }
end
