class Circuit < ApplicationRecord
  has_many :lap_times,  dependent: :destroy

  validates :name, :location, presence: true
  validates :length_km, numericality: { greater_than: 0 }, allow_nil: true
end
