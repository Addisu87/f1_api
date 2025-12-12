require 'rails_helper'

RSpec.describe "Full Integration Test", type: :request do
  describe "Complete F1 API Integration" do
    it "verifies all routes are working" do
      puts "\n=== Testing Drivers API ==="

      # Test Drivers Index
      get "/api/v1/drivers"
      puts "GET /api/v1/drivers => #{response.status}"
      expect(response).to have_http_status(200)

      # Test Drivers Create
      post "/api/v1/drivers", params: { driver: { name: "Lewis Hamilton", code: "HAM", team: "Mercedes" } }
      puts "POST /api/v1/drivers => #{response.status}"
      expect(response).to have_http_status(201)
      driver_id = JSON.parse(response.body)["id"]

      # Test Drivers Show
      get "/api/v1/drivers/#{driver_id}"
      puts "GET /api/v1/drivers/#{driver_id} => #{response.status}"
      expect(response).to have_http_status(200)

      puts "\n=== Testing Circuits API ==="

      # Test Circuits Index
      get "/api/v1/circuits"
      puts "GET /api/v1/circuits => #{response.status}"
      expect(response).to have_http_status(200)

      # Test Circuits Create
      post "/api/v1/circuits", params: { circuit: { name: "Silverstone", location: "UK", length_km: 5.9 } }
      puts "POST /api/v1/circuits => #{response.status}"
      expect(response).to have_http_status(201)
      circuit_id = JSON.parse(response.body)["id"]

      puts "\n=== Testing Lap Times API ==="

      # Test Lap Times Create
      post "/api/v1/lap_times", params: { lap_time: { driver_id: driver_id, circuit_id: circuit_id, time_ms: 90000, lap_number: 1 } }
      puts "POST /api/v1/lap_times => #{response.status}"
      expect(response).to have_http_status(201)
      lap_time_id = JSON.parse(response.body)["id"]

      # Test Lap Times Index
      get "/api/v1/lap_times"
      puts "GET /api/v1/lap_times => #{response.status}"
      expect(response).to have_http_status(200)

      # Test Lap Times Show
      get "/api/v1/lap_times/#{lap_time_id}"
      puts "GET /api/v1/lap_times/#{lap_time_id} => #{response.status}"
      expect(response).to have_http_status(200)

      puts "\n=== Testing Standings API ==="
      get "/api/v1/standings"
      puts "GET /api/v1/standings => #{response.status}"
      expect(response).to have_http_status(200)

      puts "\n=== Testing Health API ==="
      get "/api/v1/health"
      puts "GET /api/v1/health => #{response.status}"
      expect(response).to have_http_status(200)

      puts "\n=== All routes working! ==="
    end
  end
end
