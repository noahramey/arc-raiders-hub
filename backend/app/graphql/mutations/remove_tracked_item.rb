# frozen_string_literal: true

module Mutations
  class RemoveTrackedItem < Mutations::BaseMutation
    description "Stop tracking an item"

    argument :id, ID, required: true

    field :success, Boolean,  null: false
    field :errors,  [String], null: false

    def resolve(id:)
      unless context[:current_user]
        return { success: false, errors: ["Not authenticated"] }
      end

      tracked = context[:current_user].tracked_items.find_by(id: id)
      unless tracked
        return { success: false, errors: ["Tracked item not found"] }
      end

      tracked.destroy
      { success: true, errors: [] }
    end
  end
end
