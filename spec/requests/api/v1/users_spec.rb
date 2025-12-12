require 'swagger_helper'

RSpec.describe "Users API", type: :request do
  include ApiSchemas

  path "/api/v1/auth/register" do
    post "Register a new user" do
      tags "Users"
      consumes "application/json"
      produces "application/json"
      parameter name: :user, in: :body, schema: {
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
        let(:user) { { user: { email: "test@example.com", password: "123456", password_confirmation: "123456" } } }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["message"]).to eq("You've registered successfully")
          expect(data["user"]["email"]).to eq("test@example.com")
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
      parameter name: :user, in: :body, schema: {
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
        let(:user_record) { User.create!(email: "test@example.com", password: "123456") }
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
    delete "Logout user" do
      tags "Users"
      produces "application/json"
      security [bearerAuth: []]

      response "200", "logout successful" do
        let(:user_record) { User.create!(email: "test@example.com", password: "123456") }
        let(:token) { generate_jwt_token(user_record) }
        let(:Authorization) { "Bearer #{token}" }

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
