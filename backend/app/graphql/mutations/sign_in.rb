# frozen_string_literal: true

module Mutations
  class SignIn < Mutations::BaseMutation
    description "Authenticate with email + password and return a JWT"

    argument :email,    String, required: true
    argument :password, String, required: true

    field :token,  String,          null: true
    field :user,   Types::UserType, null: true
    field :errors, [String],        null: false

    def resolve(email:, password:)
      user = User.find_by(email: email.downcase.strip)

      if user&.valid_password?(password)
        token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
        { token: token, user: user, errors: [] }
      else
        { token: nil, user: nil, errors: ["Invalid email or password"] }
      end
    end
  end
end
