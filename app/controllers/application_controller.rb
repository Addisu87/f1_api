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
end
