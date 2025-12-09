require 'rails_helper'

RSpec.describe "lap_times/edit", type: :view do
  let(:lap_time) {
    LapTime.create!(
      driver: nil,
      circuit: nil,
      lap_number: 1,
      time: 1.5
    )
  }

  before(:each) do
    assign(:lap_time, lap_time)
  end

  it "renders the edit lap_time form" do
    render

    assert_select "form[action=?][method=?]", lap_time_path(lap_time), "post" do

      assert_select "input[name=?]", "lap_time[driver_id]"

      assert_select "input[name=?]", "lap_time[circuit_id]"

      assert_select "input[name=?]", "lap_time[lap_number]"

      assert_select "input[name=?]", "lap_time[time]"
    end
  end
end
