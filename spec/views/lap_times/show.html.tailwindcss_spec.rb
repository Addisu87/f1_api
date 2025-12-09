require 'rails_helper'

RSpec.describe "lap_times/show", type: :view do
  before(:each) do
    assign(:lap_time, LapTime.create!(
      driver: nil,
      circuit: nil,
      lap_number: 2,
      time: 3.5
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3.5/)
  end
end
