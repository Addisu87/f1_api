require 'swagger_helper'

RSpec.describe 'Circuits API', type: :request do
  include ApiSchemas

  let(:user) { User.create!(email: 'test@example.com', password: '123456') }
  let(:token) { generate_jwt_token(user) }

  path '/api/v1/circuits' do
    let(:Authorization) { "Bearer #{token}" }

    get 'List circuits' do
      tags 'Circuits'
      produces 'application/json'

      response '200', 'OK' do
        schema type: :array, items: ApiSchemas::Circuit
        run_test!
      end
    end

    post 'Create circuit' do
      tags 'Circuits'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :circuit, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          location: { type: :string },
          length_km: { type: :number }
        },
        required: [ 'name', 'location' ]
      }

      response '201', 'Created' do
        let(:circuit) { { name: 'Monza', location: 'Italy', length_km: 5.79 } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:circuit) { { name: 'Monza' } }
        run_test!
      end
    end
  end

  path '/api/v1/circuits/{id}' do
    parameter name: :id, in: :path, type: :integer
    let(:Authorization) { "Bearer #{token}" }

    get 'Show circuit' do
      tags 'Circuits'
      response '200', 'OK' do
        schema ApiSchemas::Circuit
        let(:id) { Circuit.create!(name: 'Spa', location: 'Belgium').id }
        run_test!
      end
    end

    patch 'Update circuit' do
      tags 'Circuits'
      consumes 'application/json'
      response '200', 'Updated' do
        let(:id) { Circuit.create!(name: 'Silverstone', location: 'UK').id }
        let(:circuit) { { length_km: 5.9 } }
        run_test!
      end
    end

    delete 'Delete circuit' do
      tags 'Circuits'
      response '204', 'Deleted' do
        let(:id) { Circuit.create!(name: 'Interlagos', location: 'Brazil').id }
        run_test!
      end
    end
  end
end
