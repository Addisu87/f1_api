require 'swagger_helper'

RSpec.describe "Users API", type: :request do
  include ApiSchemas

  path "/api/v1/auth/register" do
    post "Register a new user" do
      tags "Users"
      consumes "application/json"
      produces "application/json"
      security []  # Override global security - registration is public
      parameter name: :user, in: :body, description: 'User registration data', schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string },
              password: { type: :string },
              password_confirmation: { type: :string }
            },
            required: %w[email password password_confirmation]
          }
        }
      }

      response "200", "user registered" do
        # Use a unique email for registration test
        let(:user) { { user: { email: "newuser#{SecureRandom.hex(4)}@example.com", password: "123456", password_confirmation: "123456" } } }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["message"]).to eq("You've registered successfully")
          expect(data["user"]["email"]).to be_present
        end
      end

      response "422", "registration failed" do
        let(:user) { { user: { email: "", password: "", password_confirmation: "" } } }
        run_test!
      end
    end
  end

  path "/api/v1/auth/login" do
    post "Login user" do
      tags "Users"
      consumes "application/json"
      produces "application/json"
      security []  # Override global security - login is public
      parameter name: :user, in: :body, description: 'User login credentials', schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string },
              password: { type: :string }
            },
            required: %w[email password]
          }
        }
      }

      response "200", "login successful" do
        let(:user_record) { User.find_or_create_by!(email: "test@example.com") { |u| u.password = "123456"; u.password_confirmation = "123456" } }
        let(:user) { { user: { email: user_record.email, password: "123456" } } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["message"]).to eq("Welcome, you're in")
        end
      end

      response "401", "login failed" do
        let(:user) { { user: { email: "wrong@example.com", password: "wrong" } } }
        run_test!
      end
    end
  end

  path "/api/v1/auth/logout" do
    let(:Authorization) { "Bearer #{test_token}" }

    delete "Logout user" do
      tags "Users"
      produces "application/json"

      response "200", "logout successful" do
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["message"]).to eq("You've logged out")
        end
      end

      response "401", "logout failed" do
        let(:Authorization) { "" }
        run_test!
      end
    end
  end
end
