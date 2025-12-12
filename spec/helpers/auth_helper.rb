# frozen_string_literal: true

module AuthHelper
  # Generate a JWT token for a user using the same method as Devise JWT
  def generate_jwt_token(user)
    token, _payload = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil)
    token
  end

  # Create a user and return a JWT token
  def authenticated_user_token(email: 'test@example.com', password: '123456')
    user = User.find_or_create_by!(email: email) do |u|
      u.password = password
      u.password_confirmation = password
    end
    generate_jwt_token(user)
  end

  # Set Authorization header for Rswag tests
  def set_auth_header(token)
    { 'Authorization' => "Bearer #{token}" }
  end
end

RSpec.configure do |config|
  config.include AuthHelper, type: :request
end
