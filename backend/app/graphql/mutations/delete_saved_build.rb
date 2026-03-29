# frozen_string_literal: true

module Mutations
  class DeleteSavedBuild < Mutations::BaseMutation
    description "Delete one of the current user's saved builds"

    argument :id, ID, required: true

    field :success, Boolean,  null: false
    field :errors,  [String], null: false

    def resolve(id:)
      unless context[:current_user]
        return { success: false, errors: ["Not authenticated"] }
      end

      build = context[:current_user].saved_builds.find_by(id: id)
      unless build
        return { success: false, errors: ["Build not found"] }
      end

      build.destroy
      { success: true, errors: [] }
    end
  end
end
