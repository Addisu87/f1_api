require 'swagger_helper'

RSpec.describe 'Lap Times API', type: :request do
  include ApiSchemas

  let!(:driver) { Driver.create!(name: 'Lewis Hamilton', code: 'HAM') }
  let!(:circuit) { Circuit.create!(name: 'Silverstone', location: 'UK') }

  path '/api/v1/lap_times' do
    get 'List all lap times' do
      tags 'Lap Times'
      produces 'application/json'

      parameter name: :driver_id, in: :query, type: :integer, required: false, description: 'Filter by driver ID'
      parameter name: :circuit_id, in: :query, type: :integer, required: false, description: 'Filter by circuit ID'
      parameter name: :lap_min, in: :query, type: :integer, required: false, description: 'Minimum lap number'
      parameter name: :lap_max, in: :query, type: :integer, required: false, description: 'Maximum lap number'

      response '200', 'OK' do
        schema type: :array, items: ApiSchemas::LapTime
        run_test!
      end
    end

    post 'Create a lap time' do
      tags 'Lap Times'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :lap_time, in: :body, schema: {
        type: :object,
        properties: {
          driver_id: { type: :integer },
          circuit_id: { type: :integer },
          time_ms: { type: :integer },
          lap_number: { type: :integer }
        },
        required: %w[driver_id circuit_id time_ms lap_number]
      }

      response '201', 'Created' do
        let(:lap_time) { { driver_id: driver.id, circuit_id: circuit.id, time_ms: 80000, lap_number: 1 } }
        run_test!
      end

      response '422', 'Unprocessable' do
        let(:lap_time) { { driver_id: 1 } }
        run_test!
      end
    end
  end

  path '/api/v1/lap_times/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Show lap time' do
      tags 'Lap Times'
      produces 'application/json'

      response '200', 'OK' do
        schema ApiSchemas::LapTime
        let(:id) { LapTime.create!(driver_id: driver.id, circuit_id: circuit.id, time_ms: 80000, lap_number: 1).id }
        run_test!
      end
    end

    patch 'Update lap time' do
      tags 'Lap Times'

      consumes 'application/json'
      parameter name: :lap_time, in: :body, schema: {
        type: :object,
        properties: {
          time_ms: { type: :integer }
        }
      }

      response '200', 'Updated' do
        let(:id) { LapTime.create!(driver_id: driver.id, circuit_id: circuit.id, time_ms: 70000, lap_number: 1).id }
        let(:lap_time) { { time_ms: 65000 } }
        run_test!
      end

      response '422', 'Invalid' do
        let(:id) { LapTime.create!(driver_id: driver.id, circuit_id: circuit.id, time_ms: 70000, lap_number: 1).id }
        let(:lap_time) { { time_ms: nil } }
        run_test!
      end
    end

    delete 'Delete lap time' do
      tags 'Lap Times'

      response '204', 'Deleted' do
        let(:id) { LapTime.create!(driver_id: driver.id, circuit_id: circuit.id, time_ms: 70000, lap_number: 1).id }
        run_test!
      end
    end
  end

  path '/api/v1/drivers/{driver_id}/lap_times' do
    get 'List lap times for a driver' do
      tags 'Lap Times'
      produces 'application/json'

      parameter name: :driver_id, in: :path, type: :integer

      response '200', 'OK' do
        schema type: :array, items: ApiSchemas::LapTime
        let(:driver_id) { driver.id }
        run_test!
      end
    end
  end

  path '/api/v1/circuits/{circuit_id}/lap_times' do
    get 'Get lap times for a specific circuit' do
      tags 'Lap Times'
      produces 'application/json'

      parameter name: :circuit_id, in: :path, type: :integer, required: true

      response '200', 'lap times found' do
        schema type: :array, items: ApiSchemas::LapTime
        let(:circuit_id) { circuit.id }
        run_test!
      end
    end
  end
end
