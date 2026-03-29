# frozen_string_literal: true

module Mutations
  class SignUp < Mutations::BaseMutation
    description "Register a new user and return a JWT"

    argument :email,                 String, required: true
    argument :username,              String, required: true
    argument :password,              String, required: true
    argument :password_confirmation, String, required: true

    field :token, String,           null: true
    field :user,  Types::UserType,  null: true
    field :errors, [String],        null: false

    def resolve(email:, username:, password:, password_confirmation:)
      user = User.new(
        email: email,
        username: username,
        password: password,
        password_confirmation: password_confirmation
      )

      if user.save
        token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
        { token: token, user: user, errors: [] }
      else
        { token: nil, user: nil, errors: user.errors.full_messages }
      end
    end
  end
end
