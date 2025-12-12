class Api::V1::HealthController < ApplicationController
  def index
    render json: {
      status: "healthy",
      version: "1.0.0",
      timestamp: Time.current.iso8601
    }
  end
end
