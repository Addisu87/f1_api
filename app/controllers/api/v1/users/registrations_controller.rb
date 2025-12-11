# frozen_string_literal: true

class Api::V1::Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      render json: {
        message: "You've registered successfully",
        user: {
          id: resource.id,
          email: resource.email
        }
      }, status: :ok
    else
      render json: {
        message: "Registration failed",
        errors: resource.errors.full_messages
      }, status: :unprocessable_entity
    end
  end
end
