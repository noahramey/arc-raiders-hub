# frozen_string_literal: true

module Types
  class ItemType < Types::BaseObject
    description "A game item synced from MetaForge"

    field :id,         ID,              null: false
    field :external_id, String,         null: false
    field :name,       String,          null: false
    field :slug,       String,          null: false
    field :rarity,     String,          null: true
    field :category,   String,          null: true
    field :item_type,  String,          null: true
    field :image_url,  String,          null: true
    field :meta,       Types::JsonType, null: true
    field :synced_at,  GraphQL::Types::ISO8601DateTime, null: true
  end
end
