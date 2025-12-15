class Driver < ApplicationRecord
  has_many :lap_times, dependent: :destroy

  # Profile picture for the driver
  has_one_attached :profile_picture

  validates :name, :code, presence: true
  validates :team, presence: true, allow_nil: true
end
