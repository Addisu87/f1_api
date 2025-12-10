module Api
  module V1
    class StandingsController < ApplicationController
      POINTS = [ 25, 18, 15, 12, 10, 8, 6, 4, 2, 1 ]

      def index
        standings = LapTime
          .select("driver_id, MIN(time_ms) as best_lap")
          .group(:driver_id)
          .order("best_lap ASC")

        results = standings.map.with_index do |record, idx|
          driver = Driver.find(record.driver_id)

          {
            position: idx + 1,
            driver: driver.name,
            best_lap: record.best_lap,
            points: POINTS[idx] || 0
          }
        end

        render json: results
      end
    end
  end
end
