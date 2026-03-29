# frozen_string_literal: true

module Types
  class TrackedItemType < Types::BaseObject
    description "An item the user is tracking their collection progress on"

    field :id,               ID,             null: false
    field :item,             Types::ItemType, null: false
    field :quantity_needed,  Integer,         null: false
    field :quantity_current, Integer,         null: false
  end
end
