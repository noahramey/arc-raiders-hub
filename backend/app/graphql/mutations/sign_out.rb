# frozen_string_literal: true

module Mutations
  class SignOut < Mutations::BaseMutation
    description "Revoke the current user's JWT (requires authentication)"

    field :success, Boolean, null: false
    field :errors,  [String], null: false

    def resolve
      user = context[:current_user]
      unless user
        return { success: false, errors: ["Not authenticated"] }
      end

      # Rotate the jti to invalidate the current token (JTIMatcher strategy)
      user.update_column(:jti, SecureRandom.uuid)
      { success: true, errors: [] }
    end
  end
end
