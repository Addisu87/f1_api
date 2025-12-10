class DriverSerializer < ActiveModel::Serializer
  attributes :id, :name, :code, :team, :country, :created_at, :updated_at
end
