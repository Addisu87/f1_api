class HomeController < ApplicationController
  def index
    render json: { message: "F1 API is running" }
  end
end
