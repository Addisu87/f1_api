class Driver < ApplicationRecord
  has_many :lap_times,  dependent: :destroy
end
