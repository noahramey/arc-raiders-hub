# frozen_string_literal: true

module Mutations
  class UpdateTrackedItem < Mutations::BaseMutation
    description "Update quantity fields on a tracked item"

    argument :id,               ID,      required: true
    argument :quantity_needed,  Integer, required: false
    argument :quantity_current, Integer, required: false

    field :tracked_item, Types::TrackedItemType, null: true
    field :errors,       [String],               null: false

    def resolve(id:, quantity_needed: nil, quantity_current: nil)
      unless context[:current_user]
        return { tracked_item: nil, errors: ["Not authenticated"] }
      end

      tracked = context[:current_user].tracked_items.find_by(id: id)
      return { tracked_item: nil, errors: ["Tracked item not found"] } unless tracked

      attrs = {}
      attrs[:quantity_needed]  = quantity_needed  unless quantity_needed.nil?
      attrs[:quantity_current] = quantity_current unless quantity_current.nil?

      if tracked.update(attrs)
        { tracked_item: tracked, errors: [] }
      else
        { tracked_item: nil, errors: tracked.errors.full_messages }
      end
    end
  end
end
