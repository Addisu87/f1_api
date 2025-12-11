# frozen_string_literal: true

require 'jwt'

class Api::V1::BaseController < ApplicationController
  respond_to :json

  before_action :authenticate_user!

  private

  # Override to authenticate using JWT token from Authorization header
  def authenticate_user!
    token = extract_token_from_header
    
    if token
      authenticate_with_jwt_token(token)
    else
      render json: { error: 'Missing Authorization header' }, status: :unauthorized
    end
  end

  def authenticate_with_jwt_token(token)
    # Decode JWT using Devise's configured secret
    payload = decode_jwt_token(token)
    user = User.find(payload['sub'])
    
    # Check token revocation (Devise JWT revocation strategy)
    if payload['jti'].present? && JwtDenylist.exists?(jti: payload['jti'])
      render json: { error: 'Token has been revoked' }, status: :unauthorized
      return
    end
    
    # Sign in user statelessly (no session storage for API)
    sign_in(user, store: false)
  rescue JWT::DecodeError, JWT::ExpiredSignature, ActiveRecord::RecordNotFound
    render json: { error: 'Invalid or expired token' }, status: :unauthorized
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

