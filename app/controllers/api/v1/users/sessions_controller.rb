# frozen_string_literal: true

class Api::V1::Users::SessionsController < Devise::SessionsController
  respond_to :json

  # Login does NOT require a token - it's a public endpoint
  # Users provide email/password and receive a JWT token back
  # Allow login even if already authenticated (to get fresh token)
  skip_before_action :require_no_authentication, only: [ :create ]
  skip_before_action :verify_signed_out_user, only: [ :destroy ]

  # POST /api/v1/auth/login
  def create
    self.resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)

    render json: {
      message: "Welcome, you're in",
      user: { id: resource.id, email: resource.email },
      token: jwt_token,
      token_type: "Bearer"
    }, status: :ok
  rescue Warden::NotAuthenticated
    render json: { message: "Invalid email or password" }, status: :unauthorized
  end

  # DELETE /api/v1/auth/logout
  def destroy
    sign_out(resource_name)
    render json: { message: "You've logged out" }, status: :ok
  end

  private

  def jwt_token
    # Devise JWT automatically generates token when sign_in is called
    request.env["warden-jwt_auth.token"] || generate_jwt_token
  end

  def generate_jwt_token
    aud = resource.jwt_audience(request)
    Warden::JWTAuth::UserEncoder.new.call(resource, :user, aud).first
  rescue => e
    Rails.logger.error "Failed to generate JWT token: #{e.message}"
    nil
  end
end
