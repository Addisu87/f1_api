# frozen_string_literal: true

class Api::V1::Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
  #
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    render json: { message: "Welcome, you're in", user: current_user }, status: :ok
  end

  def respond_to_on_destroy
    successful_logout && return if current_user
    failed_logout
  end

  def successful_logout
    render json: { message: "You've logged out" }, status: :ok
  end

  def failed_logout
    render json: { message: "Something went wrong." }, status: :unauthorized
  end
end
