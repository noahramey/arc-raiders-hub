# frozen_string_literal: true

class GraphqlController < ApplicationController
  before_action :authenticate_user_from_token!

  def execute
    variables = prepare_variables(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    context = {
      current_user: current_user
    }
    result = BackendSchema.execute(query, variables: variables, context: context, operation_name: operation_name)
    render json: result
  rescue StandardError => e
    raise e unless Rails.env.development?
    handle_error_in_development(e)
  end

  private

  # Attempt to authenticate from the JWT in the Authorization header.
  # Does not halt the request — unauthenticated users can still run public queries.
  def authenticate_user_from_token!
    header = request.headers["Authorization"]
    return unless header&.start_with?("Bearer ")

    token = header.split(" ", 2).last
    payload = Warden::JWTAuth::TokenDecoder.new.call(token)
    @current_user = User.find_by(id: payload["sub"])
  rescue JWT::DecodeError, Warden::JWTAuth::Errors::RevokedToken
    # Invalid or revoked token — treat as unauthenticated
    @current_user = nil
  end

  def current_user
    @current_user
  end

  # Handle variables in form data, JSON body, or a blank value
  def prepare_variables(variables_param)
    case variables_param
    when String
      variables_param.present? ? JSON.parse(variables_param) || {} : {}
    when Hash
      variables_param
    when ActionController::Parameters
      variables_param.to_unsafe_hash
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{variables_param}"
    end
  end

  def handle_error_in_development(e)
    logger.error e.message
    logger.error e.backtrace.join("\n")
    render json: { errors: [{ message: e.message, backtrace: e.backtrace }], data: {} }, status: 500
  end
end
