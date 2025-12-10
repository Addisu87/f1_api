# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require "faker"

puts "Seeding drivers..."
8.times do
  Driver.create!(
    name: Faker::Sports::FormulaOne.driver,
    code: Faker::Alphanumeric.alpha(number: 3).upcase,
    country: Faker::Address.country
  )
end

puts "Seeding circuits..."
8.times do
  Circuit.create!(
    name: Faker::Sports::FormulaOne.location,
    location: Faker::Address.city
  )
end

puts "Seeding lap times..."
drivers = Driver.all
circuits = Circuit.all

drivers.each do |driver|
  circuits.sample(10).each do |circuit|
    rand(15..25).times do |lap|
      LapTime.create!(
        driver: driver,
        circuit: circuit,
        lap_number: lap + 1,
        time_ms: rand(65_000..105_000) # 65s–105s
      )
    end
  end
end
