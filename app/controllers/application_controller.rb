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
  end

  # Override authenticate_user! to enforce JWT authentication for API
  def authenticate_user!(opts = {})
    # Require Authorization header with Bearer token
    auth_header = request.headers['Authorization']
    
    if auth_header.blank? || !auth_header.start_with?('Bearer ')
      render json: {
        error: 'Unauthorized',
        message: 'Missing or invalid authentication token'
      }, status: :unauthorized
      return
    end
    
    # Authenticate using Warden JWT strategy
    warden.authenticate!(scope: :user, strategy: :jwt_authenticatable)
  rescue Warden::NotAuthenticated
    render json: {
      error: 'Unauthorized',
      message: 'Invalid or expired authentication token'
    }, status: :unauthorized
  end
end
