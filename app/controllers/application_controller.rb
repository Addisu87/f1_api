class ApplicationController < ActionController::Base
  # Skip CSRF protection for API-only application
  # APIs use JWT tokens for authentication, not CSRF tokens
  skip_before_action :verify_authenticity_token

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

    unless auth_header&.start_with?("Bearer ")
      return render_unauthorized("Missing or invalid authentication token.")
    end

    warden.authenticate!(scope: :user, strategy: :jwt_authenticatable)
  rescue Warden::NotAuthenticated => e
    log_error(e, "JWT Authentication failed")
    render_unauthorized("Invalid or expired authentication token")
  rescue => e
    log_error(e, "Authentication error")
    render_unauthorized("Authentication failed")
  end

  private

  def render_unauthorized(message)
    render json: { error: "Unauthorized", message: message }, status: :unauthorized
  end

  def log_error(error, context)
    Rails.logger.error "#{context}: #{error.class} - #{error.message}"
    Rails.logger.error error.backtrace.first(5).join("\n") if error.backtrace
  end
end
