# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.openapi_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under openapi_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a openapi_spec tag to the
  # the root example_group in your specs, e.g. describe '...', openapi_spec: 'v2/swagger.json'
  config.openapi_specs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'F1 Laps API',
        version: 'v1',
        description: 'API for accessing Formula 1 lap time data and analytics',
        contact: {
          name: 'API Support',
          email: 'support@f1laps.com'
        },
        license: {
          name: 'MIT',
          url: 'https://opensource.org/licenses/MIT'
        }
      },
      paths: {},
      tags: [
        {
          name: 'Health',
          description: 'API health check endpoint'
        },
        {
          name: 'Users',
          description: 'User authentication and registration endpoints'
        },
        {
          name: 'Drivers',
          description: 'F1 driver management endpoints'
        },
        {
          name: 'Circuits',
          description: 'F1 circuit management endpoints'
        },
        {
          name: 'Lap Times',
          description: 'Lap time tracking and fastest lap endpoints'
        },
        {
          name: 'Standings',
          description: 'Driver standings and rankings'
        }
      ],
      components: {
        securitySchemes: {
          bearer_auth: {
            type: :http,
            scheme: :bearer,
            bearerFormat: 'JWT',
            description: 'JWT token obtained from /api/v1/auth/login endpoint. Format: Bearer {token}'
          }
        }
      },
      security: [ { bearerAuth: [] } ],
      servers: [
        {
          url: 'http://localhost:3000',
          description: 'Development server'
        },
        {
          url: 'https://{customHost}',
          description: 'Production server',
          variables: {
            customHost: {
              default: 'your-production-domain.com',
              description: 'Your production API domain'
            }
          }
        }
      ]
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The openapi_specs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.openapi_format = :yaml

  # Post-process generated Swagger file to remove any real JWT tokens
  # Replace with empty value so users must enter their own token
  config.after(:suite) do
    swagger_file = Rails.root.join('swagger', 'v1', 'swagger.yaml')
    if File.exist?(swagger_file)
      content = File.read(swagger_file)
      # Remove any real JWT tokens - leave empty so users enter their own
      sanitized = content.gsub(/Bearer\s+eyJ[A-Za-z0-9_-]{20,}/, '')
      File.write(swagger_file, sanitized) if sanitized != content
    end
  end
end
