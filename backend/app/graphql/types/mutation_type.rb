# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    # Auth
    field :sign_up,  mutation: Mutations::SignUp
    field :sign_in,  mutation: Mutations::SignIn
    field :sign_out, mutation: Mutations::SignOut

    # Saved builds
    field :create_saved_build, mutation: Mutations::CreateSavedBuild
    field :delete_saved_build, mutation: Mutations::DeleteSavedBuild

    # Item tracker
    field :add_tracked_item,    mutation: Mutations::AddTrackedItem
    field :update_tracked_item, mutation: Mutations::UpdateTrackedItem
    field :remove_tracked_item, mutation: Mutations::RemoveTrackedItem
  end
end
