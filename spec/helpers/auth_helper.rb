# frozen_string_literal: true

module AuthHelper
  # Generate a JWT token for a user using Devise JWT encoder
  def generate_jwt_token(user)
    token, _payload = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil)
    token
  end

  # Create a user and return a JWT token
  def authenticated_token(email: 'test@example.com', password: '123456')
    user = User.find_or_create_by!(email: email) do |u|
      u.password = password
      u.password_confirmation = password
    end
    generate_jwt_token(user)
  end

  # Alias for backward compatibility
  alias_method :authenticated_user_token, :authenticated_token
end

RSpec.configure do |config|
  config.include AuthHelper, type: :request
end
