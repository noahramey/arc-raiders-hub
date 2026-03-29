# frozen_string_literal: true

module Types
  class MapType < Types::BaseObject
    description "Map data synced from MetaForge"

    field :id,        ID,              null: false
    field :name,      String,          null: false
    field :slug,      String,          null: false
    field :data,      Types::JsonType, null: true
    field :synced_at, GraphQL::Types::ISO8601DateTime, null: true
  end
end
