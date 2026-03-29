# frozen_string_literal: true

module Types
  class QuestType < Types::BaseObject
    description "A quest synced from MetaForge"

    field :id,             ID,              null: false
    field :external_id,    String,          null: false
    field :name,           String,          null: false
    field :slug,           String,          null: false
    field :difficulty,     String,          null: true
    field :rewards,        Types::JsonType, null: true
    field :required_items, Types::JsonType, null: true
    field :synced_at,      GraphQL::Types::ISO8601DateTime, null: true
  end
end
