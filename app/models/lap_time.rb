class LapTime < ApplicationRecord
  belongs_to :driver
  belongs_to :circuit

  validates :lap_number, numericality: { only_integer: true, greater_than: 0 }
  validates :time, numericality: true
end
