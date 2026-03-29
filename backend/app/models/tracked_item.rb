class TrackedItem < ApplicationRecord
  belongs_to :user
  belongs_to :item

  validates :quantity_needed, numericality: { greater_than: 0 }
  validates :quantity_current, numericality: { greater_than_or_equal_to: 0 }
  validates :item_id, uniqueness: { scope: :user_id, message: "is already being tracked" }
end
