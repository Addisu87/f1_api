require 'rails_helper'

RSpec.describe "lap_times/index", type: :view do
  before(:each) do
    assign(:lap_times, [
      LapTime.create!(
        driver: nil,
        circuit: nil,
        lap_number: 2,
        time: 3.5
      ),
      LapTime.create!(
        driver: nil,
        circuit: nil,
        lap_number: 2,
        time: 3.5
      )
    ])
  end

  it "renders a list of lap_times" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(3.5.to_s), count: 2
  end
end
