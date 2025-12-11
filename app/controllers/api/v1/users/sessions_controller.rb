# frozen_string_literal: true

require 'jwt'

class Api::V1::Users::SessionsController < Devise::SessionsController
  respond_to :json
  
  # Allow login even if already authenticated (to get fresh token)
  skip_before_action :require_no_authentication, only: [:create]
  skip_before_action :verify_signed_out_user, only: [:destroy]

  # POST /api/v1/auth/login
  # Following Devise patterns: https://github.com/heartcombo/devise
  def create
    self.resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)
    
    # Generate JWT token using Devise's JWT configuration from devise.rb
    jwt_token = generate_jwt_token(resource)
    
    # Return token in response body for API clients
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
    revoke_jwt_token
    sign_out(resource_name)
    render json: { message: "You've logged out" }, status: :ok
  end

  private

  def generate_jwt_token(user)
    # Use Devise JWT configuration from config/initializers/devise.rb
    jti = SecureRandom.uuid
    payload = {
      sub: user.id.to_s,
      jti: jti,
      exp: 24.hours.from_now.to_i
    }
    JWT.encode(payload, Rails.application.credentials.secret_key_base, 'HS256')
  end

  def revoke_jwt_token
    token = extract_token_from_header
    return unless token
    
    payload = decode_jwt_token(token)
    return unless payload['jti']
    
    JwtDenylist.find_or_create_by(jti: payload['jti']) do |entry|
      entry.exp = Time.at(payload['exp']) if payload['exp']
    end
  rescue JWT::DecodeError, JWT::ExpiredSignature
    # Token invalid/expired, but logout still succeeds
  end

  def extract_token_from_header
    auth_header = request.headers['Authorization']
    return nil unless auth_header
    auth_header.start_with?('Bearer ') ? auth_header.split(' ').last : auth_header
  end

  def decode_jwt_token(token)
    decoded = JWT.decode(
      token,
      Rails.application.credentials.secret_key_base,
      true,
      { algorithm: 'HS256' }
    )
    decoded[0]
  end
end
