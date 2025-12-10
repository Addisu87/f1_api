class Driver < ApplicationRecord
  has_many :lap_times,  dependent: :destroy

  validates :name, :code, presence: true
  validates :team, presence: true, allow_nil: true
end
