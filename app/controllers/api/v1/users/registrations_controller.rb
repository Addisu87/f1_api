# frozen_string_literal: true

class Api::V1::Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # POST /resource
  # def create
  #   super do |resource|
  #   # use a custom mailer to send an email to the admin
  #   AdminNotifierMailer.user_signup_notification(resource).deliver_later
  # end
  #
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    successful_registration && return if resource.persisted?
    failed_registration
  end

  def successful_registration
    render json: { message: "You've registered successfully", user: current_user }, status: :ok
  end

  def failed_registration
    render json: { message: "Something went wrong. Please try again" }, status: :unprocessable_entity
  end
end
