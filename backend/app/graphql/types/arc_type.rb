# frozen_string_literal: true

module Types
  class ArcType < Types::BaseObject
    description "An ARC/encounter synced from MetaForge"

    field :id,          ID,              null: false
    field :external_id, String,          null: false
    field :name,        String,          null: false
    field :slug,        String,          null: false
    field :loot,        Types::JsonType, null: true
    field :synced_at,   GraphQL::Types::ISO8601DateTime, null: true
  end
end
