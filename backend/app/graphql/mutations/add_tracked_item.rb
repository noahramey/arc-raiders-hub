# frozen_string_literal: true

module Mutations
  class AddTrackedItem < Mutations::BaseMutation
    description "Start tracking an item's collection progress"

    argument :item_id,          ID,      required: true
    argument :quantity_needed,  Integer, required: false, default_value: 1
    argument :quantity_current, Integer, required: false, default_value: 0

    field :tracked_item, Types::TrackedItemType, null: true
    field :errors,       [String],               null: false

    def resolve(item_id:, quantity_needed:, quantity_current:)
      unless context[:current_user]
        return { tracked_item: nil, errors: ["Not authenticated"] }
      end

      item = Item.find_by(id: item_id)
      return { tracked_item: nil, errors: ["Item not found"] } unless item

      tracked = context[:current_user].tracked_items.build(
        item: item,
        quantity_needed: quantity_needed,
        quantity_current: quantity_current
      )

      if tracked.save
        { tracked_item: tracked, errors: [] }
      else
        { tracked_item: nil, errors: tracked.errors.full_messages }
      end
    end
  end
end
