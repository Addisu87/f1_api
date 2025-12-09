require 'swagger_helper'

RSpec.describe 'LapTimes API', type: :request do
  path '/api/v1/lap_times' do
    get 'List lap times' do
      tags 'LapTimes'
      produces 'application/json'

      parameter name: :driver_id,  in: :query, type: :integer
      parameter name: :circuit_id, in: :query, type: :integer
      parameter name: :lap_number, in: :query, type: :integer

      response '200', 'success' do
        run_test!
      end
    end

    post 'Create lap time' do
      tags 'LapTimes'
      consumes 'application/json'
      parameter name: :lap_time, in: :body, schema: {
        type: :object,
        properties: {
          driver_id: { type: :integer },
          circuit_id: { type: :integer },
          lap_number: { type: :integer },
          time: { type: :number }
        },
        required: %w[driver_id circuit_id lap_number time]
      }

      response '201', 'created' do
        run_test!
      end
    end
  end
end
