class Api::V1::HealthController < ApplicationController
  # Health check endpoint is public and doesn't require authentication
  respond_to :json

  def index
    render json: {
      status: "healthy",
      version: "1.0.0",
      timestamp: Time.current.iso8601
    }
  end
end
