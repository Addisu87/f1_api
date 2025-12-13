require 'swagger_helper'

RSpec.describe 'Standings API', type: :request do
  path '/api/v1/standings' do
    let(:Authorization) { "Bearer #{test_token}" }

    get 'Get driver standings' do
      tags 'Standings'
      produces 'application/json'
      description 'Returns driver standings based on their fastest lap times. Drivers are ranked by their best lap time, with points awarded to the top 10 positions (25, 18, 15, 12, 10, 8, 6, 4, 2, 1).'

      response '200', 'standings retrieved' do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              position: {
                type: :integer,
                description: 'Driver position in standings (1st, 2nd, 3rd, etc.)'
              },
              driver: {
                type: :string,
                description: 'Driver name'
              },
              best_lap: {
                type: :integer,
                description: 'Best lap time in milliseconds'
              },
              points: {
                type: :integer,
                description: 'Championship points (25 for 1st, 18 for 2nd, etc.)'
              }
            },
            required: [ 'position', 'driver', 'best_lap', 'points' ]
          },
          example: [
            {
              position: 1,
              driver: 'Lewis Hamilton',
              best_lap: 85430,
              points: 25
            },
            {
              position: 2,
              driver: 'Max Verstappen',
              best_lap: 85892,
              points: 18
            }
          ]

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to be_an(Array)
        end
      end

      response '401', 'unauthorized' do
        schema type: :object,
          properties: {
            error: { type: :string }
          }

        let(:Authorization) { '' }
        run_test!
      end
    end
  end
end
