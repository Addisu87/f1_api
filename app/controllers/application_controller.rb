class ApplicationController < ActionController::Base
  # Skip CSRF protection for API-only application
  # APIs use JWT tokens for authentication, not CSRF tokens
  skip_before_action :verify_authenticity_token

  # Skip browser checks and importmap for API-only application
  # All routes are API routes or documentation

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :email, :password, :password_confirmation ])
    devise_parameter_sanitizer.permit(:sign_in, keys: [ :email, :password ])
  end

  # Override authenticate_user! to enforce JWT authentication for API
  def authenticate_user!(opts = {})
    auth_header = request.headers["Authorization"]

    if auth_header.blank? || !auth_header.start_with?("Bearer ")
      render json: {
        error: "Unauthorized",
        message: "Missing or invalid authentication token. Please provide a Bearer token in the Authorization header."
      }, status: :unauthorized
      return
    end

    # Authenticate using Warden JWT strategy
    warden.authenticate!(scope: :user, strategy: :jwt_authenticatable)
  rescue Warden::NotAuthenticated => e
    Rails.logger.error "JWT Authentication failed: #{e.message}"
    render json: {
      error: "Unauthorized",
      message: "Invalid or expired authentication token"
    }, status: :unauthorized
  rescue => e
    Rails.logger.error "Authentication error: #{e.class} - #{e.message}"
    render json: {
      error: "Unauthorized",
      message: "Authentication failed"
    }, status: :unauthorized
  end
end
