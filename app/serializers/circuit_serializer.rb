class CircuitSerializer < ActiveModel::Serializer
  attributes :id, :name, :location, :length_km, :created_at, :updated_at
end
