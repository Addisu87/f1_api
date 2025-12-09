require "rails_helper"

RSpec.describe LapTimesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/lap_times").to route_to("lap_times#index")
    end

    it "routes to #new" do
      expect(get: "/lap_times/new").to route_to("lap_times#new")
    end

    it "routes to #show" do
      expect(get: "/lap_times/1").to route_to("lap_times#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/lap_times/1/edit").to route_to("lap_times#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/lap_times").to route_to("lap_times#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/lap_times/1").to route_to("lap_times#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/lap_times/1").to route_to("lap_times#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/lap_times/1").to route_to("lap_times#destroy", id: "1")
    end
  end
end
