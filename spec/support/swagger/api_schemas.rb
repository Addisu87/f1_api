# spec/support/swagger/schemas.rb
RSpec.configure do |config|
  config.openapi_root = Rails.root.join("swagger").to_s

  config.after(:suite) do
    FileUtils.rm_rf(Rails.root.join('swagger'))
  end
end

module ApiSchemas
  USER_SCHEMA = {
    type: :object,
    properties: {
      id: { type: :integer },
      email: { type: :string },
      created_at: { type: :string, format: "date-time" },
      updated_at: { type: :string, format: "date-time" }
    },
    required: %w[id email]
  }.freeze

  AUTH_RESPONSE_SCHEMA = {
    type: :object,
    properties: {
      message: { type: :string },
      user: USER_SCHEMA
    },
    required: %w[message user]
  }.freeze


  Driver = {
    type: :object,
    properties: {
      id: { type: :integer },
      name: { type: :string },
      code: { type: :string },
      team: { type: :string },
      country: { type: :string },
      created_at: { type: :string, format: 'date-time' },
      updated_at: { type: :string, format: 'date-time' }
    },
    required: %w[id name code]
  }

  Circuit = {
    type: :object,
    properties: {
      id: { type: :integer },
      name: { type: :string },
      location: { type: :string },
      length_km: { type: [ :number, :null ] },
      created_at: { type: :string, format: 'date-time' },
      updated_at: { type: :string, format: 'date-time' }
    },
    required: %w[id name location]
  }

  LapTime = {
    type: :object,
    properties: {
      id: { type: :integer },
      driver_id: { type: :integer },
      circuit_id: { type: :integer },
      time_ms: { type: :integer },
      lap_number: { type: :integer },
      created_at: { type: :string, format: 'date-time' },
      updated_at: { type: :string, format: 'date-time' }
    },
    required: %w[id driver_id circuit_id time_ms lap_number]
  }
end
