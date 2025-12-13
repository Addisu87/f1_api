# frozen_string_literal: true

module AuthHelper
  # Create a test user for authentication
  def test_user(email: 'test@example.com', password: '123456')
    User.find_or_create_by!(email: email) do |u|
      u.password = password
      u.password_confirmation = password
    end
  end

  # Generate a JWT token for a user using Devise JWT encoder
  def generate_jwt_token(user)
    token, _payload = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil)
    token
  end

  # Create a test user and generate a JWT token for it
  def test_token(email: 'test@example.com', password: '123456')
    user = test_user(email: email, password: password)
    generate_jwt_token(user)
  end

  # Legacy method name for backward compatibility
  def authenticated_token(email: 'test@example.com', password: '123456')
    test_token(email: email, password: password)
  end

  alias_method :authenticated_user_token, :authenticated_token
end

RSpec.configure do |config|
  config.include AuthHelper, type: :request
end
