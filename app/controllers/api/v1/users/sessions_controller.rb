# frozen_string_literal: true

require 'jwt'

class Api::V1::Users::SessionsController < Devise::SessionsController
  respond_to :json
  
  # Skip Devise's require_no_authentication filter for APIs
  # APIs should allow login even if user is already authenticated (to get fresh token)
  skip_before_action :require_no_authentication, only: [:create]
  skip_before_action :verify_signed_out_user, only: [:destroy]

  # POST /api/v1/auth/login
  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    
    # Generate JWT token (same way devise-jwt does it)
    jwt_token = generate_jwt_token(resource)
    
    # Return JSON with token in body for easy copy-paste in Swagger UI
    render json: {
      message: "Welcome, you're in",
      user: {
        id: resource.id,
        email: resource.email
      },
      token: jwt_token,
      token_type: "Bearer"
    }, status: :ok
  rescue => e
    render json: {
      message: "Invalid email or password",
      error: e.message
    }, status: :unauthorized
  end

  # DELETE /api/v1/auth/logout
  def destroy
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message!(:notice, :signed_out) if signed_out
    
    render json: { message: "You've logged out" }, status: :ok
  end

  private

  def generate_jwt_token(user)
    # Generate JWT token using the same secret and expiration as devise-jwt
    payload = {
      sub: user.id,
      exp: 24.hours.from_now.to_i
    }
    JWT.encode(payload, Rails.application.credentials.secret_key_base, 'HS256')
  end

  def respond_with(resource, _opts = {})
    # This method is called by Devise, but we handle response in create action
    # Keeping for compatibility
  end

  def respond_to_on_destroy
    # Handled in destroy action
  end
end
