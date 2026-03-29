# frozen_string_literal: true

module Types
  class EventScheduleType < Types::BaseObject
    description "An event schedule synced from MetaForge"

    field :id,        ID,              null: false
    field :name,      String,          null: false
    field :schedule,  Types::JsonType, null: true
    field :synced_at, GraphQL::Types::ISO8601DateTime, null: true
  end
end
