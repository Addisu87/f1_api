# frozen_string_literal: true

class Api::V1::Users::SessionsController < Devise::SessionsController
  respond_to :json
  
  # Allow login even if already authenticated (to get fresh token)
  skip_before_action :require_no_authentication, only: [:create]
  skip_before_action :verify_signed_out_user, only: [:destroy]

  # POST /api/v1/auth/login
  def create
    self.resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)
    
    # Generate JWT token using Devise JWT's encoder (reuses Devise configuration)
    jwt_token = generate_jwt_token
    
    render json: {
      message: "Welcome, you're in",
      user: {
        id: resource.id,
        email: resource.email
      },
      token: jwt_token,
      token_type: "Bearer"
    }, status: :ok
  rescue Warden::NotAuthenticated
    render json: {
      message: "Invalid email or password"
    }, status: :unauthorized
  end

  # DELETE /api/v1/auth/logout
  def destroy
    sign_out(resource_name)
    render json: { message: "You've logged out" }, status: :ok
  end

  private

  # Generate JWT token using Devise JWT's encoder
  # This reuses Devise JWT's configured secret and expiration settings
  def generate_jwt_token
    token, _payload = Warden::JWTAuth::UserEncoder.new.call(resource, :user, request)
    token
  rescue => e
    Rails.logger.error "Failed to generate JWT token: #{e.message}"
    nil
  end
end
