# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    # ── Game data ────────────────────────────────────────────────────────────

    field :items, [Types::ItemType], null: false,
      description: "All items"
    def items
      Item.all
    end

    field :item, Types::ItemType, null: true,
      description: "Fetch a single item by slug" do
      argument :slug, String, required: true
    end
    def item(slug:)
      Item.find_by(slug: slug)
    end

    field :quests, [Types::QuestType], null: false,
      description: "All quests"
    def quests
      Quest.all
    end

    field :quest, Types::QuestType, null: true,
      description: "Fetch a single quest by slug" do
      argument :slug, String, required: true
    end
    def quest(slug:)
      Quest.find_by(slug: slug)
    end

    field :arcs, [Types::ArcType], null: false,
      description: "All ARCs/encounters"
    def arcs
      Arc.all
    end

    field :arc, Types::ArcType, null: true,
      description: "Fetch a single ARC by slug" do
      argument :slug, String, required: true
    end
    def arc(slug:)
      Arc.find_by(slug: slug)
    end

    field :traders, [Types::TraderType], null: false,
      description: "All traders"
    def traders
      Trader.all
    end

    field :maps, [Types::MapType], null: false,
      description: "All maps"
    def maps
      MapDatum.all
    end

    field :map, Types::MapType, null: true,
      description: "Fetch a single map by slug" do
      argument :slug, String, required: true
    end
    def map(slug:)
      MapDatum.find_by(slug: slug)
    end

    field :event_schedules, [Types::EventScheduleType], null: false,
      description: "All event schedules"
    def event_schedules
      EventSchedule.all
    end

    # ── User-specific ────────────────────────────────────────────────────────

    field :current_user, Types::UserType, null: true,
      description: "The currently authenticated user"
    def current_user
      context[:current_user]
    end

    field :saved_builds, [Types::SavedBuildType], null: false,
      description: "Saved builds for the current user"
    def saved_builds
      return [] unless context[:current_user]
      context[:current_user].saved_builds
    end

    field :tracked_items, [Types::TrackedItemType], null: false,
      description: "Tracked items for the current user"
    def tracked_items
      return [] unless context[:current_user]
      context[:current_user].tracked_items.includes(:item)
    end
  end
end

