require 'swagger_helper'

RSpec.describe 'Drivers API', type: :request do
  include ApiSchemas

  let(:user) { User.create!(email: 'test@example.com', password: '123456') }
  let(:token) { generate_jwt_token(user) }
  let(:Authorization) { "Bearer #{token}" }

  path '/api/v1/drivers' do
    get 'List drivers' do
      tags 'Drivers'
      produces 'application/json'
      security [bearerAuth: []]

      response '200', 'OK' do
        schema type: :array, items: ApiSchemas::Driver
        run_test!
      end
    end

    post 'Create driver' do
      tags 'Drivers'
      consumes 'application/json'
      produces 'application/json'
      security [bearerAuth: []]

      parameter name: :driver, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          code: { type: :string },
          team: { type: :string }
        },
        required: [ 'name', 'code' ]
      }

      response '201', 'Created' do
        let(:driver) {
          {
            name: 'Lewis Hamilton', code: 'Ham', team: 'Mercedes'
          }
        }
        run_test!
      end

      response '422', 'invalid request' do
        let(:driver) { { name: 'Lewis Hamilton' } }
        run_test!
      end
    end
  end

  path '/api/v1/drivers/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Show driver' do
      tags 'Drivers'
      response '200', 'OK' do
        schema ApiSchemas::Driver
        let(:id) { Driver.create!(name: 'Max Verstappen', code: 'VER').id }
        run_test!
      end
    end

    patch 'Update driver' do
      tags 'Drivers'
      consumes 'application/json'

      response '200', 'Updated' do
        let(:id) { Driver.create!(name: 'Charles Leclerc', code: 'LEC').id }
        let(:driver) { { team: 'Ferrari' } }
        run_test!
      end
    end

    delete 'Delete driver' do
      tags 'Drivers'
      response '204', 'Deleted' do
        let(:id) { Driver.create!(name: 'Lando Norris', code: 'NOR').id }
        run_test!
      end
    end
  end
end
