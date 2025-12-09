require 'rails_helper'

RSpec.describe "lap_times/new", type: :view do
  before(:each) do
    assign(:lap_time, LapTime.new(
      driver: nil,
      circuit: nil,
      lap_number: 1,
      time: 1.5
    ))
  end

  it "renders new lap_time form" do
    render

    assert_select "form[action=?][method=?]", lap_times_path, "post" do

      assert_select "input[name=?]", "lap_time[driver_id]"

      assert_select "input[name=?]", "lap_time[circuit_id]"

      assert_select "input[name=?]", "lap_time[lap_number]"

      assert_select "input[name=?]", "lap_time[time]"
    end
  end
end
