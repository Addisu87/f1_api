# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
#

puts "Seeding database..."

# ----------------------------
# Users
# ----------------------------
User.destroy_all
user = User.create!(
  email: "test@example.com",
  password: "password123",
  password_confirmation: "password123"
)
puts "Created user: #{user.email}"

# ----------------------------
# Drivers
# ----------------------------
Driver.destroy_all

drivers = Driver.create!([
  { name: "Lewis Hamilton", code: "HAM", team: "Mercedes", country: "United Kingdom" },
  { name: "Max Verstappen", code: "VER", team: "Red Bull Racing", country: "Netherlands" },
  { name: "Charles Leclerc", code: "LEC", team: "Ferrari", country: "Monaco" }
])

puts "Created #{drivers.count} drivers."

# ----------------------------
# Circuits
# ----------------------------
Circuit.destroy_all

circuits = Circuit.create!([
  { name: "Silverstone Circuit", location: "United Kingdom", length_km: 5.891 },
  { name: "Monza Circuit", location: "Italy", length_km: 5.793 },
  { name: "Circuit de Monaco", location: "Monaco", length_km: 3.337 }
])

puts "Created #{circuits.count} circuits."

# ----------------------------
# Lap Times
# ----------------------------
LapTime.destroy_all

lap_times = [
  { driver: drivers[0], circuit: circuits[0], lap_number: 1, time_ms: 89000 },
  { driver: drivers[0], circuit: circuits[1], lap_number: 1, time_ms: 87000 },

  { driver: drivers[1], circuit: circuits[0], lap_number: 1, time_ms: 88000 },
  { driver: drivers[1], circuit: circuits[2], lap_number: 1, time_ms: 72000 },

  { driver: drivers[2], circuit: circuits[1], lap_number: 1, time_ms: 86500 },
  { driver: drivers[2], circuit: circuits[2], lap_number: 1, time_ms: 73000 }
]

LapTime.create!(lap_times)

puts "Created #{lap_times.count} lap times."

# ----------------------------
# Summary
# ----------------------------
puts "--------------------------------"
puts "Seeding completed successfully!"
puts "Users: #{User.count}"
puts "Drivers: #{Driver.count}"
puts "Circuits: #{Circuit.count}"
puts "Lap Times: #{LapTime.count}"
puts "--------------------------------"
