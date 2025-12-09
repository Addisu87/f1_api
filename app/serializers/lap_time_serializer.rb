class LapTimeSerializer < ActiveModel::Serializer
  attributes :id, :lap_number, :time
  has_one :driver
  has_one :circuit
end
