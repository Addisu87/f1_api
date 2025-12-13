class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  # Override jwt_audience to use a consistent string identifier
  # According to JWT spec (RFC 7519), 'aud' (audience) should be a string or array of strings
  # identifying the recipients that the JWT is intended for
  def jwt_audience(request = nil)
    "api/v1"
  end
end
