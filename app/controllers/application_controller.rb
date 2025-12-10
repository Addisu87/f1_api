class ApplicationController < ActionController::Base
  # Skip browser checks and importmap for API-only application
  # All routes are API routes or documentation
  
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :username ])
  end
end
