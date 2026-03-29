# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    description "An authenticated user"

    field :id,       ID,     null: false
    field :email,    String, null: false
    field :username, String, null: false

    field :saved_builds,  [Types::SavedBuildType],  null: false
    field :tracked_items, [Types::TrackedItemType], null: false
  end
end
