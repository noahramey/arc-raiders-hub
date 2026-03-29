# frozen_string_literal: true

module Types
  class SavedBuildType < Types::BaseObject
    description "A saved loadout build belonging to a user"

    field :id,         ID,              null: false
    field :name,       String,          null: false
    field :items,      Types::JsonType, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
