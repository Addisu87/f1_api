class LapTimeSerializer < ActiveModel::Serializer
  attributes :id, :driver_id, :circuit_id, :lap_number, :time_ms, :created_at, :updated_at
end
