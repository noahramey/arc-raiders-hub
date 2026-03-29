# frozen_string_literal: true

module Mutations
  class CreateSavedBuild < Mutations::BaseMutation
    description "Create a named saved build for the current user"

    argument :name,  String,          required: true
    argument :items, Types::JsonType, required: false

    field :saved_build, Types::SavedBuildType, null: true
    field :errors,      [String],              null: false

    def resolve(name:, items: [])
      unless context[:current_user]
        return { saved_build: nil, errors: ["Not authenticated"] }
      end

      build = context[:current_user].saved_builds.build(name: name, items: items)

      if build.save
        { saved_build: build, errors: [] }
      else
        { saved_build: nil, errors: build.errors.full_messages }
      end
    end
  end
end
