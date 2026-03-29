# frozen_string_literal: true

module Types
  class TraderType < Types::BaseObject
    description "A trader synced from MetaForge"

    field :id,          ID,              null: false
    field :external_id, String,          null: false
    field :name,        String,          null: false
    field :inventory,   Types::JsonType, null: true
    field :synced_at,   GraphQL::Types::ISO8601DateTime, null: true
  end
end
