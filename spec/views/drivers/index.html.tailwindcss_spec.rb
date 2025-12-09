require 'rails_helper'

RSpec.describe "drivers/index", type: :view do
  before(:each) do
    assign(:drivers, [
      Driver.create!(
        name: "Name",
        code: "Code",
        country: "Country"
      ),
      Driver.create!(
        name: "Name",
        code: "Code",
        country: "Country"
      )
    ])
  end

  it "renders a list of drivers" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Code".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Country".to_s), count: 2
  end
end
