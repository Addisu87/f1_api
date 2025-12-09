json.extract! lap_time, :id, :driver_id, :circuit_id, :lap_number, :time, :created_at, :updated_at
json.url lap_time_url(lap_time, format: :json)
